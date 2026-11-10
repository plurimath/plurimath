# frozen_string_literal: true

# Regenerates the generated regions of the format specifications
# (docs/mathml.adoc, docs/omml.adoc, docs/unicodemath.adoc, docs/latex.adoc
# and docs/unitsml.adoc), so that their option tables, construct and element
# tables, examples and corpus counts come from the code and the shared
# testsuite, never from hand-kept prose.
#
# Usage, from the Plurimath checkout:
#
#   bundle exec ruby scripts/docs/format_specs.rb [--testsuite PATH] [--check]
#
# PATH is a plurimath-testsuite git repository that contains the commit
# recorded for submodules/plurimath-testsuite in this checkout's HEAD. It
# defaults to the submodule itself. Only that commit is read, through git, so
# the working tree of PATH does not matter.
#
# Every example is a Ruby expression that the script evaluates with this
# checkout and its bundle; the page shows the expression and its result. The
# result is written as it is returned, except that OMML examples leave out the
# namespace declarations on m:oMathPara, which are the same for every output
# and listed once in docs/omml.adoc.
#
# Without --check it rewrites the regions between
# "// BEGIN GENERATED <name>" and "// END GENERATED <name>". With --check it
# writes nothing and exits 1 when a page differs from what it would write.
# The output depends only on the code, the bundle and the testsuite commit,
# never on time or local paths.

$LOAD_PATH.unshift(File.expand_path("../../lib", __dir__))
require "plurimath"
require "prism"
require "yaml"
require "open3"
require "ox"

module FormatSpecs
  ROOT = File.expand_path("../..", __dir__)
  SUBMODULE = "submodules/plurimath-testsuite"

  class Error < StandardError; end

  # One entry per page: the writer method documented, the corpus directory
  # holding inputs in the format, the corpus target name and the roundtrip
  # generation key for output in the format.
  PAGES = {
    "mathml" => { writer: :to_mathml, corpus: "mathml", target: "mathml", roundtrip: "mathml" },
    "omml" => { writer: :to_omml, corpus: "omml", target: "omml", roundtrip: "omml" },
    "unicodemath" => { writer: :to_unicodemath, corpus: "unicode", target: "unicodemath", roundtrip: "unicode" },
    "latex" => { writer: :to_latex, corpus: "latex", target: "latex", roundtrip: nil },
    "unitsml" => { writer: nil, corpus: nil, target: nil, roundtrip: nil },
  }.freeze

  # The examples, by page and region name. Each is evaluated as written.
  EXAMPLES = {
    "mathml" => {
      "write" => 'Plurimath::Math.parse("x^2", :asciimath).to_mathml',
      "write-inline" => 'Plurimath::Math.parse("x^2", :asciimath).to_mathml(display_style: false)',
      "intent-abs" => 'Plurimath::Math.parse("abs(x)", :asciimath).to_mathml(intent: true)',
      "intent-sum" => 'Plurimath::Math.parse("sum_(i=1)^n i", :asciimath).to_mathml(intent: true)',
      "intent-read" => "Plurimath::Math.parse('<math><mrow intent=\"absolute-value(x)\"><mo>|</mo><mi>x</mi><mo>|</mo></mrow></math>', :mathml).to_mathml(intent: true)",
      "linebreak" => 'Plurimath::Math.parse("a = b \\\\\\\\ c = d", :latex).to_mathml(split_on_linebreak: true)',
      "unary-spacing" => 'Plurimath::Math.parse("2 sin x", :asciimath).to_mathml',
      "unary-spacing-off" => 'Plurimath::Math.parse("2 sin x", :asciimath).to_mathml(unary_function_spacing: false)',
      "uncertainty" => 'Plurimath::Math.parse("ustd(1.230, 0.004)", :asciimath).to_mathml',
      "read-no-namespace" => "Plurimath::Math.parse('<math><mi>x</mi><mo>+</mo><mn>1</mn></math>', :mathml).to_asciimath",
      "read-prefixed" => "Plurimath::Math.parse('<mml:math xmlns:mml=\"http://www.w3.org/1998/Math/MathML\"><mml:mi>x</mml:mi></mml:math>', :mathml).to_asciimath",
      "read-mfenced" => "Plurimath::Math.parse('<math><mfenced><mi>x</mi></mfenced></math>', :mathml).to_asciimath",
      "read-inline" => "Plurimath::Math.parse('<math display=\"inline\"><mi>x</mi></math>', :mathml).to_mathml",
      "read-unknown" => "Plurimath::Math.parse('<math><foo>x</foo></math>', :mathml).to_asciimath.inspect",
      "read-no-rule" => "Plurimath::Math.parse('<math><apply><ci>x</ci></apply></math>', :mathml)",
      "read-maction" => "Plurimath::Math.parse('<math><maction actiontype=\"toggle\" selection=\"2\"><mi>x</mi><mi>y</mi></maction></math>', :mathml).to_asciimath",
      "read-malformed" => "Plurimath::Math.parse('<math><mi>x</math>', :mathml)",
      "read-locale" => "Plurimath::Math.parse('<math><mn>1</mn></math>', :mathml, locale: :de)",
    },
    "omml" => {
      "write" => 'Plurimath::Math.parse("x^2", :asciimath).to_omml',
      "limits-display" => 'Plurimath::Math.parse("lim_(x->0) x", :asciimath).to_omml',
      "limits-inline" => 'Plurimath::Math.parse("lim_(x->0) x", :asciimath).to_omml(display_style: false)',
      "linebreak" => 'Plurimath::Math.parse("a = b \\\\\\\\ c = d", :latex).to_omml(split_on_linebreak: true)',
      "readback" => 'Plurimath::Math.parse(Plurimath::Math.parse("x^2 + 2", :asciimath).to_omml, :omml).to_asciimath',
      "read-styled" => "Plurimath::Math.parse('<m:oMath xmlns:m=\"http://schemas.openxmlformats.org/officeDocument/2006/math\"><m:r><m:rPr><m:sty m:val=\"i\"/></m:rPr><m:t>x</m:t></m:r></m:oMath>', :omml).to_asciimath",
      "read-unknown" => "Plurimath::Math.parse('<m:oMath xmlns:m=\"http://schemas.openxmlformats.org/officeDocument/2006/math\"><m:foo/></m:oMath>', :omml).to_asciimath.inspect",
      "read-nested-para" => "Plurimath::Math.parse('<m:oMath xmlns:m=\"http://schemas.openxmlformats.org/officeDocument/2006/math\"><m:sSup><m:e><m:oMathPara><m:oMath><m:r><m:t>x</m:t></m:r></m:oMath></m:oMathPara></m:e><m:sup><m:r><m:t>2</m:t></m:r></m:sup></m:sSup></m:oMath>', :omml).to_asciimath",
      "uncertainty" => 'Plurimath::Math.parse("ustd(1.230, 0.004)", :asciimath).to_omml',
    },
    "unicodemath" => {
      "write" => 'Plurimath::Math.parse("x^2 + frac(a)(b) + sqrt(x)", :asciimath).to_unicodemath',
      "write-symbols" => 'Plurimath::Math.parse("alpha + oo", :asciimath).to_unicodemath',
      "read" => 'Plurimath::Math.parse("(a)/(b) + √(x)", :unicode).to_asciimath',
      "read-escape-short" => 'Plurimath::Math.parse("\\\\u3b1+1", :unicode).to_latex',
      "read-escape" => 'Plurimath::Math.parse("\\\\u03B1+1", :unicode).to_latex',
      "read-escape-trailing" => 'Plurimath::Math.parse("\\\\u03B1x+1", :unicode).to_latex',
      "read-label" => 'Plurimath::Math.parse("E=mc^2#(1)", :unicode).to_mathml',
      "read-label-twice" => 'Plurimath::Math.parse("x#(1)#(2)", :unicode).to_asciimath',
      "read-label-quoted" => 'Plurimath::Math.parse(%q("a#b"), :unicode)',
      "read-locale" => 'Plurimath::Math.parse("1,5", :unicode, locale: :de).value.map(&:class)',
      "read-wrong-type" => 'Plurimath::Math.parse("x^2", :unicodemath)',
      "uncertainty" => 'Plurimath::Math.parse("ustd(1.230, 0.004)", :asciimath).to_unicodemath',
      "uncertainty-negative" => 'Plurimath::Math.parse("ustd(-1.230, 0.004)", :asciimath).to_unicodemath',
      "uncertainty-unit" => 'Plurimath::Math.parse(%q(ustd(1.2, 0.1, "unitsml(kg)")), :asciimath).to_unicodemath',
      "uncertainty-unit-readback" => 'Plurimath::Math.parse("ⓘ(\"standard-uncertainty(1.2,0.1,$unit)\"1.2(0.1)ⓐ(unit \\\\mup\"kg\"))", :unicode).to_asciimath',
    },
    "latex" => {
      "write" => 'Plurimath::Math.parse("frac(a)(b) + sqrt(x) + sum_(i=1)^n i", :asciimath).to_latex',
      "write-text" => 'Plurimath::Math.parse(%q("speed" = d/t), :asciimath).to_latex',
      "write-symbols" => 'Plurimath::Math.parse("alpha + oo", :asciimath).to_latex',
      "write-colour" => 'Plurimath::Math.parse("color(red)(x)", :asciimath).to_latex',
      "read" => 'Plurimath::Math.parse("\\\\frac{a}{b} + \\\\sqrt{x}", :latex).to_asciimath',
      "read-decimal-default" => 'Plurimath::Math.parse("1,5", :latex).value.map(&:class)',
      "read-decimal-locale" => 'Plurimath::Math.parse("1,5", :latex, locale: :de).value.map(&:class)',
      "read-refused" => 'Plurimath::Math.parse("\\\\frac{a}{", :latex)',
      "uncertainty-standard" => 'Plurimath::Math.parse("ustd(1.230, 0.004)", :asciimath).to_latex',
      "uncertainty-interval" => 'Plurimath::Math.parse("ucov(1.024, 0.983, 1.088, 0.95, shortest)", :asciimath).to_latex',
      "uncertainty-readback" => 'Plurimath::Math.parse("1.024,\\\\ [0.983, 1.088],\\\\ p = 0.95", :latex).to_asciimath',
    },
    "unitsml" => {
      "asciimath" => 'Plurimath::Math.parse(%q(9.8 "unitsml(m*s^-2)"), :asciimath).to_asciimath',
      "latex" => 'Plurimath::Math.parse(%q(9.8 "unitsml(m*s^-2)"), :asciimath).to_latex',
      "unicodemath" => 'Plurimath::Math.parse(%q(9.8 "unitsml(m*s^-2)"), :asciimath).to_unicodemath',
      "html" => 'Plurimath::Math.parse(%q(9.8 "unitsml(m*s^-2)"), :asciimath).to_html',
      "mathml" => 'Plurimath::Math.parse(%q(9.8 "unitsml(m*s^-2)"), :asciimath).to_mathml',
      "unitsml-xml" => 'Plurimath::Math.parse(%q("unitsml(m)"), :asciimath).to_mathml(unitsml: { xml: true })',
      "multiplier" => 'Plurimath::Math.parse(%q(9.8 "unitsml(m*s^-2)"), :asciimath).to_asciimath(unitsml: { multiplier: :space })',
      "dimension" => 'Plurimath::Math.parse(%q("unitsml(dim_L)"), :asciimath).to_asciimath',
      "type" => 'Plurimath::Math.parse("m*s^-2", :unitsml).class',
      "type-write-direct" => 'Plurimath::Math.parse("m*s^-2", :unitsml).to_asciimath',
      "type-variable-exponent" => 'Plurimath::Math.parse("m^x", :unitsml)',
      "type-unknown" => 'Plurimath::Math.parse("foo", :unitsml)',
      "latex-input" => 'Plurimath::Math.parse("9.8 \\\\unitsml{m}", :latex)',
      "readback-mathml" => 'Plurimath::Math.parse(Plurimath::Math.parse(%q(9.8 "unitsml(m)"), :asciimath).to_mathml, :mathml).to_asciimath',
    },
  }.freeze

  # The construct tables of the LaTeX and UnicodeMath pages: a name and an
  # input in the page's format. Each input is read, written as AsciiMath and
  # written back in the same format.
  CONSTRUCTS = {
    "latex" => [
      ["Number", "12.5"],
      ["Letter", "x"],
      ["Superscript", "x^{2}"],
      ["Subscript", "x_{i}"],
      ["Both scripts", "x_{i}^{2}"],
      ["Fraction", '\frac{a}{b}'],
      ["Binomial", '\binom{n}{k}'],
      ["Square root", '\sqrt{x}'],
      ["Root with index", '\sqrt[3]{x}'],
      ["Sum with limits", '\sum_{i=1}^{n} i'],
      ["Integral", '\int_{0}^{1} f(x) dx'],
      ["Limit", '\lim_{x \to 0} x'],
      ["Function name", '\sin x'],
      ["Operator name", '\operatorname{sgn} x'],
      ["Symbols", '\alpha + \infty'],
      ["Relation", 'x \le y'],
      ["Brackets", '\left( x \right)'],
      ["Bracket on one side", '\left\{ x \right.'],
      ["Matrix", '\begin{matrix} a & b \\\\ c & d \end{matrix}'],
      ["Matrix in brackets", '\begin{pmatrix} a & b \end{pmatrix}'],
      ["Cases", '\begin{cases} a & b \end{cases}'],
      ["Text", '\text{if}'],
      ["Font", '\mathbf{x}'],
      ["Upright font", '\mathrm{d}x'],
      ["Accent", '\hat{x}'],
      ["Overline", '\overline{x}'],
      ["Brace with label", '\overbrace{x}^{n}'],
      ["Colour", '\color{red}{x}'],
    ],
    "unicodemath" => [
      ["Number", "12.5"],
      ["Letter", "x"],
      ["Superscript", "x^2"],
      ["Subscript", "x_i"],
      ["Both scripts", "x_i^2"],
      ["Fraction", "a/b"],
      ["Stacked, no bar", "a¦b"],
      ["Square root", "√x"],
      ["Cube root", "∛x"],
      ["Root with index", "√(3&x)"],
      ["Sum with limits", "∑_(i=1)^n i"],
      ["Integral", "∫_0^1 f(x) dx"],
      ["Limit", "lim_(x→0) x"],
      ["Function name", "sin x"],
      ["Symbols", "α+∞"],
      ["Control word", '\alpha'],
      ["Relation", "x≤y"],
      ["Brackets", "(x)"],
      ["Matrix", "■(a&b@c&d)"],
      ["Matrix in brackets", "(■(a&b@c&d))"],
      ["Matrix in brackets, short form", "⒨(a&b)"],
      ["Bracket on one side", "{■(a&b)┤"],
      ["Text", '"if"'],
      ["Bold letter", "𝐱"],
      ["Combining accent", "x̂"],
      ["Combining overline", "x̅"],
      ["Brace with label", "⏞(x)^n"],
    ],
  }.freeze

  # The construct tables of the MathML and OMML pages: a name and an
  # AsciiMath input, written in the page's format.
  WRITTEN_CONSTRUCTS = [
    ["Number and letter", "2x"],
    ["Operator", "a + b"],
    ["Superscript", "x^2"],
    ["Both scripts", "x_i^2"],
    ["Fraction", "frac(a)(b)"],
    ["Square root", "sqrt(x)"],
    ["Root with index", "root(3)(x)"],
    ["Sum with limits", "sum_(i=1)^n i"],
    ["Integral", "int_0^1 f(x) dx"],
    ["Limit", "lim_(x->0) x"],
    ["Function name", "sin x"],
    ["Brackets", "(x)"],
    ["Absolute value", "abs(x)"],
    ["Matrix", "[[a, b], [c, d]]"],
    ["Text", '"if"'],
    ["Font", "bb(x)"],
    ["Accent", "hat(x)"],
    ["Overline", "bar(x)"],
    ["Brace with label", "overbrace(x)(n)"],
    ["Colour", "color(red)(x)"],
    ["Line break", "a \\\\ b"],
  ].freeze

  # The units of the UnitsML page, each written after the number 9.8.
  UNITS = %w[m m*s^-2 kg*m^2*s^-3 J/kg N*m mm^2 um degC dim_L].freeze
  UNIT_WRITERS = %i[to_asciimath to_latex to_unicodemath to_html].freeze

  # Where each page's reader dispatches on node class, for the element
  # tables.
  DISPATCH = {
    "mathml" => ["lib/plurimath/mathml/translator.rb", :mml_to_plurimath],
    "omml" => ["lib/plurimath/omml/translator.rb", :translate_omml_node],
  }.freeze

  OMML_PARA = /\A<m:oMathPara(?: [^>]*)?>/

  module_function

  def run(argv)
    options = parse_args(argv)
    engine = Plurimath.xml_engine.to_s
    unless engine == "Plurimath::XmlEngine::OxEngine"
      raise Error, "the examples are written with the Ox engine; #{engine} is selected"
    end

    corpus = Corpus.new(options.fetch(:testsuite), submodule_commit)
    stale = PAGES.keys.reject do |page|
      path = File.join(ROOT, "docs", "#{page}.adoc")
      current = File.read(path, encoding: "UTF-8")
      updated = replace_regions(page, current, build_regions(page, corpus))
      next true if current == updated
      next false if options[:check]

      File.write(path, updated)
      puts "updated docs/#{page}.adoc"
      true
    end
    return 0 if stale.empty?

    stale.each { |page| warn "docs/#{page}.adoc is out of date; run scripts/docs/format_specs.rb" }
    1
  end

  def parse_args(argv)
    options = { check: false, testsuite: File.join(ROOT, SUBMODULE) }
    args = argv.dup
    until args.empty?
      case (arg = args.shift)
      when "--testsuite" then options[:testsuite] = File.expand_path(args.shift.to_s)
      when "--check" then options[:check] = true
      else raise Error, "unknown argument #{arg.inspect}"
      end
    end
    options
  end

  def submodule_commit
    out, status = Open3.capture2("git", "-C", ROOT, "rev-parse", "HEAD:#{SUBMODULE}")
    raise Error, "cannot read the #{SUBMODULE} commit from HEAD" unless status.success?

    out.strip
  end

  def build_regions(page, corpus)
    config = PAGES.fetch(page)
    regions = {}
    regions["writer-options"] = writer_options(config[:writer]) if config[:writer]
    regions["unitsml-options"] = unitsml_options if page == "unitsml"
    regions["omml-namespaces"] = omml_namespaces if page == "omml"
    regions["conformance"] = corpus.table(config, page)
    regions["constructs"] = construct_table(page) if CONSTRUCTS.key?(page)
    regions["elements-read"] = elements_read(page) if DISPATCH.key?(page)
    regions["elements-written"] = elements_written(page) if DISPATCH.key?(page)
    regions["units"] = units_table if page == "unitsml"
    EXAMPLES.fetch(page).each do |name, code|
      regions["example #{name}"] = example(page, code)
    end
    regions
  end

  # The keyword parameters of Formula#<writer> and their default
  # expressions, read from the method's source.
  def writer_options(writer)
    file, line = Plurimath::Math::Formula.instance_method(writer).source_location
    node = Prism.parse_file(file).value.breadth_first_search do |candidate|
      candidate.is_a?(Prism::DefNode) && candidate.name == writer &&
        candidate.location.start_line == line
    end
    raise Error, "cannot find Formula##{writer} in #{file}" unless node

    rows = (node.parameters&.keywords || []).map do |param|
      default = param.respond_to?(:value) ? "`#{param.value.slice}`" : "required"
      "|`#{param.name}:` |#{default}"
    end
    relative = file.delete_prefix("#{ROOT}/")
    [
      "`Plurimath::Math::Formula##{writer}` in `#{relative}` takes these keyword options:",
      "",
      "[cols=\"1,1\"]",
      "|===",
      "|Option |Default",
      "",
      *rows,
      "|===",
    ]
  end

  # The option keys the unitsml gem reads from the options hash it is
  # given, found in its source, and the one key Plurimath reads itself.
  def unitsml_options
    spec = Gem.loaded_specs.fetch("unitsml")
    keys = Hash.new { |hash, key| hash[key] = [] }
    Dir.glob(File.join(spec.full_gem_path, "lib/unitsml/*.rb")).each do |path|
      File.read(path, encoding: "UTF-8").scan(/options(?:\[|\.key\?\(|\.fetch\()\s*:([a-z_]+)/) do |(key)|
        keys[key] << File.basename(path)
      end
    end
    plurimath_file = Plurimath::Math::Function::Unitsml.instance_method(:to_mathml_without_math_tag).source_location.first
    File.read(plurimath_file, encoding: "UTF-8").scan(/dig\(:unitsml,\s*:([a-z_]+)\)/m) do |(key)|
      keys[key] << "Plurimath #{File.basename(plurimath_file)}"
    end
    rows = keys.keys.sort.map { |key| "|`#{key}` |#{keys[key].uniq.sort.join(', ')}" }
    [
      "unitsml #{spec.version}, the version the bundle loads:",
      "",
      "[cols=\"1,2\"]",
      "|===",
      "|Key |Read in",
      "",
      *rows,
      "|===",
    ]
  end

  def omml_namespaces
    rows = Plurimath::Math::Formula::OMML_NAMESPACES.map { |prefix, uri| "|`#{prefix}` |`#{uri}`" }
    ["[cols=\"1,3\"]", "|===", "|Declaration |Namespace", "", *rows, "|==="]
  end

  # Each construct read from the page's format, written as AsciiMath and
  # written back in the format.
  def construct_table(page)
    format = page == "unicodemath" ? :unicode : page.to_sym
    writer = PAGES.fetch(page).fetch(:writer)
    rows = CONSTRUCTS.fetch(page).map do |name, input|
      formula = Plurimath::Math.parse(input, format)
      [name, input, outcome { formula.to_asciimath }, outcome { formula.public_send(writer) }]
    rescue StandardError => e
      [name, input, "refused: #{e.class}", "-"]
    end
    table(%w[Construct Input AsciiMath Written\ back], "2,3l,3l,3l", rows)
  end

  # The value of the block, or the class of the error it raised.
  def outcome
    value = yield
    value.is_a?(String) ? value : value.inspect
  rescue StandardError => e
    "raises #{e.class}"
  end

  # One row per element class the reader dispatches on, from the `case` in
  # the reader's dispatch method, with the element names the model maps to
  # that class.
  def elements_read(page)
    file, method = DISPATCH.fetch(page)
    names = page == "mathml" ? method(:mathml_element_names) : omml_element_names
    rows = dispatch_entries(file, method).flat_map do |classes, handler|
      classes.map { |klass| [names.call(klass), "`#{klass.split('::').last}`", handler] }
    end
    rows = rows.reject { |element, _, _| element.nil? }.sort_by(&:first)
    handled = rows.map(&:first)
    rows = rows.map { |element, klass, handler| ["`#{element}`", klass, handler] }
    lines = [
      "`#{method}` in `#{file}` handles these model classes:",
      "",
      *table(["Element", "Model class", "Read by"], "2,2,3", rows),
    ]
    return lines unless page == "mathml"

    others = mathml_model_elements - handled
    lines + [
      "",
      "The mml model has #{others.size} more element classes, which the " \
      "translator has no rule for: #{others.sort.map { |e| "`#{e}`" }.join(', ')}.",
    ]
  end

  # The element names of the mml MathML 4 model classes.
  def mathml_model_elements
    Mml::V4.constants.filter_map do |name|
      klass = Mml::V4.const_get(name)
      next unless klass.is_a?(Class) && klass.respond_to?(:mappings_for)

      klass.mappings_for(:xml).root_element
    end.uniq
  end

  # [[class names], handler] for each `when` of the `case` in +method+.
  def dispatch_entries(file, method)
    path = File.join(ROOT, file)
    definition = Prism.parse_file(path).value.breadth_first_search do |node|
      node.is_a?(Prism::DefNode) && node.name == method
    end
    raise Error, "cannot find #{method} in #{file}" unless definition

    kase = definition.body.body.find { |node| node.is_a?(Prism::CaseNode) }
    raise Error, "#{method} in #{file} has no case" unless kase

    kase.conditions.map do |w|
      classes = w.conditions.map { |c| c.is_a?(Prism::StringNode) ? c.unescaped : c.slice }
      call = w.statements&.body&.last
      handler = if call.nil? || call.is_a?(Prism::NilNode) then "ignored, no node"
                elsif call.is_a?(Prism::CallNode) && call.receiver.nil? then "`#{call.name}`"
                else "`#{call.slice}`"
                end
      [classes.reject { |c| c == "String" }, handler]
    end
  end

  def mathml_element_names(klass)
    Plurimath.load_mml
    Object.const_get(klass).mappings_for(:xml).root_element
  end

  # The element names, with prefix, under which the omml model reads each
  # of its classes inside m:oMathPara or m:oMath: the two root elements, and
  # every element reached from them through the model's XML mappings. The
  # type names are the file names in the gem's autoload table.
  def omml_element_names
    Plurimath.load_mml
    require "omml"
    source = File.read(File.join(Gem.loaded_specs.fetch("omml").full_gem_path, "lib/omml/models.rb"))
    types = source.scan(%r{autoload :(\w+),\s*"omml/models/(?:groups/)?(\w+)"}).to_h { |c, f| [f.to_sym, c] }
    names = Hash.new { |hash, key| hash[key] = [] }
    queue = %w[OMathPara OMath]
    queue.each { |name| names[name] << "m:#{::Omml::Models.const_get(name).mappings_for(:xml).root_element}" }
    register = ::Omml::Configuration.context_id
    ::Omml::Configuration.populate_context! unless ::Omml::Configuration.context(register)
    prefixes = [::Omml::Namespace, ::Omml::WordprocessingNamespace].to_h { |ns| [ns.uri, ns.prefix_default] }
    seen = {}
    until queue.empty?
      name = queue.shift
      next if seen[name]

      seen[name] = true
      klass = ::Omml::Models.const_get(name)
      klass.ensure_imports!(register)
      mapping = klass.mappings_for(:xml, register)
      mapping.elements(register).each do |rule|
        attribute = klass.attributes(register)[rule.to] or next
        type = attribute.instance_variable_get(:@unresolved_type)
        target = type.is_a?(Symbol) ? types[type] : nil
        next unless target

        # An element imported from a group keeps the group's namespace.
        uri = rule.namespace_class&.uri ||
          rule.instance_variable_get(:@default_namespace) ||
          mapping.namespace_class.uri
        names[target] << "#{prefixes.fetch(uri)}:#{rule.name}"
        queue << target
      end
    end
    lambda do |klass|
      list = names[klass].uniq.sort
      list.empty? ? nil : list.join(", ")
    end
  end

  # The elements each construct is written with, leaving out the wrapper
  # elements every output has and, for OMML, the property elements.
  def elements_written(page)
    writer = PAGES.fetch(page).fetch(:writer)
    rows = WRITTEN_CONSTRUCTS.map do |name, input|
      xml = Plurimath::Math.parse(input, :asciimath).public_send(writer)
      [name, input, element_names(Ox.parse(xml), page).uniq.join(" ")]
    end
    table(%w[Construct AsciiMath Elements], "2,2l,4l", rows)
  end

  # The element names under +node+ in document order. The outer wrappers,
  # matched by depth, are left out.
  def element_names(node, page, depth = 0)
    return [] unless node.is_a?(Ox::Element)
    return [] if page == "omml" && node.name.end_with?("Pr")

    wrappers = page == "mathml" ? %w[math mstyle] : %w[m:oMathPara m:oMath]
    wrapper = wrappers[depth] == node.name
    own = wrapper ? [] : [node.name]
    own + node.nodes.flat_map { |child| element_names(child, page, wrapper ? depth + 1 : wrappers.size) }
  end

  # Each unit after a number, written in the four text formats.
  def units_table
    rows = UNITS.map do |unit|
      formula = Plurimath::Math.parse(%(9.8 "unitsml(#{unit})"), :asciimath)
      [unit, *UNIT_WRITERS.map { |w| outcome { formula.public_send(w) } }]
    end
    table(%w[Unit AsciiMath LaTeX UnicodeMath HTML], "1l,2l,2l,2l,2l", rows)
  end

  # An AsciiDoc table with a header row. +cols+ sets the column widths and
  # styles; a `|` in a cell is escaped.
  def table(header, cols, rows)
    body = rows.map { |row| row.map { |cell| "|#{cell.to_s.gsub('|', '\|')}" }.join(" ") }
    ["[cols=\"#{cols}\",options=\"header\"]", "|===", header.map { |h| "|#{h}" }.join(" "), *body, "|==="]
  end

  def example(page, code)
    result = begin
      value = TOPLEVEL_BINDING.eval(code, __FILE__, __LINE__)
      value.is_a?(String) ? value : value.inspect
    rescue StandardError => e
      "raises #{e.class}"
    end
    result = result.sub(OMML_PARA, '<m:oMathPara xmlns:m="..." ...>') if page == "omml"
    language = output_language(result)
    [
      "[source,ruby]",
      "----",
      code,
      "----",
      "",
      language ? "[source,#{language}]" : "[source]",
      "----",
      result.chomp,
      "----",
    ]
  end

  def output_language(result)
    "xml" if result.start_with?("<")
  end

  def replace_regions(page, text, regions)
    regions.reduce(text) do |doc, (name, lines)|
      pattern = %r{(^// BEGIN GENERATED #{Regexp.escape(name)}\n).*?(^// END GENERATED #{Regexp.escape(name)}$)}m
      raise Error, "docs/#{page}.adoc has no generated region #{name.inspect}" unless doc.match?(pattern)

      doc.sub(pattern) { "#{Regexp.last_match(1)}#{lines.join("\n")}\n#{Regexp.last_match(2)}" }
    end
  end

  # Counts from the corpus/ snapshot and the roundtrip generation at the
  # testsuite commit this checkout pins.
  class Corpus
    ROUNDTRIP = "stages/roundtrip/generations/000001/payloads"

    def initialize(repository, commit)
      @repository = repository
      @commit = commit
      _out, status = Open3.capture2e("git", "-C", repository, "cat-file", "-e", "#{commit}^{commit}")
      raise Error, "#{repository} does not contain testsuite commit #{commit}" unless status.success?
    end

    def table(config, page)
      lines = ["Shared testsuite at `#{@commit}` (the `#{SUBMODULE}` commit):", ""]
      lines += page == "unitsml" ? unitsml_rows : format_rows(config)
      lines
    end

    private

    def format_rows(config)
      inputs = payloads("corpus/#{config[:corpus]}")
      refused, read = inputs.partition { |p| rejection?(p) }
      written = payloads("corpus").reject { |p| rejection?(p) }
        .select { |p| Array(p["targets"]).include?(config[:target]) }
      rows = [
        ["`corpus/#{config[:corpus]}/`, inputs read", cases(read), groups(read)],
        ["`corpus/#{config[:corpus]}/rejections.yaml`, inputs refused", cases(refused), groups(refused)],
        ["`corpus/*/`, cases with `#{config[:target]}` output", cases(written), "#{written.size} payloads"],
      ]
      rows << roundtrip_row(config[:roundtrip]) if config[:roundtrip]
      render(rows)
    end

    def unitsml_rows
      all = payloads("corpus").reject { |p| rejection?(p) }
      calls = all.select { |p| p["cases"].any? { |c| c.dig("call", "method") == "unitsml" } }
      embedded = all.sum { |p| p["cases"].count { |c| c["input"].to_s.include?("unitsml(") } }
      embedded_groups = all.select { |p| p["cases"].any? { |c| c["input"].to_s.include?("unitsml(") } }
      units = payloads(ROUNDTRIP).sum { |p| p["cases"].count { |c| c.dig("source", "input").to_s.include?("unitsml(") } }
      render([
               ["`corpus/*/`, cases whose input embeds `unitsml(...)`", embedded, groups(embedded_groups)],
               ["`corpus/*/`, cases rendered with `unitsml:` options", cases(calls), groups(calls)],
               ["`#{ROUNDTRIP}/`, cases whose input embeds `unitsml(...)`", units, "-"],
             ])
    end

    def roundtrip_row(key)
      tally = Hash.new(0)
      payloads(ROUNDTRIP).each do |payload|
        payload["cases"].each do |kase|
          outcome = kase.dig("expected", key)
          next unless outcome

          tally[outcome_name(outcome)] += 1
        end
      end
      summary = tally.sort.map { |name, count| "#{count} #{name}" }.join(", ")
      ["`#{ROUNDTRIP}/`, written as `#{key}` and read back", tally.values.sum, summary]
    end

    def outcome_name(outcome)
      return "refused" unless outcome.key?("lossless")

      outcome["lossless"] ? "lossless" : "lossy"
    end

    def render(rows)
      body = rows.map { |label, count, detail| "|#{label} |#{count} |#{detail}" }
      ["[cols=\"3,1,3\"]", "|===", "|Rows |Cases |Groups", "", *body, "|==="]
    end

    def cases(list)
      list.sum { |payload| payload["cases"].size }
    end

    def groups(list)
      names = list.map { |payload| payload["group"] || "rejections" }.uniq.sort
      names.empty? ? "-" : names.map { |n| "`#{n}`" }.join(", ")
    end

    def rejection?(payload)
      payload["schema"].to_s.start_with?("plurimath-corpus/rejections/")
    end

    def payloads(dir)
      out, status = Open3.capture2("git", "-C", @repository, "ls-tree", "-r", "--name-only", @commit, "#{dir}/")
      raise Error, "cannot list #{dir} at #{@commit}" unless status.success?

      out.split("\n").grep(/\.yaml\z/).reject { |path| File.basename(path) == "provenance.yaml" }.sort.map do |path|
        text, read = Open3.capture2("git", "-C", @repository, "show", "#{@commit}:#{path}")
        raise Error, "cannot read #{path} at #{@commit}" unless read.success?

        YAML.safe_load(text, aliases: false)
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    exit FormatSpecs.run(ARGV)
  rescue FormatSpecs::Error => e
    warn "format_specs: #{e.message}"
    exit 2
  end
end
