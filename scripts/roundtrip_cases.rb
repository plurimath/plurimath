# frozen_string_literal: true

# Writes the cross-language uncertainty round-trip cases for
# plurimath-testsuite (stages/roundtrip/generations/<NNNNNN>/payloads/
# <group>.yaml, schema plurimath-stage/roundtrip/1).
#
# Each case is one uncertainty input in AsciiMath, UnicodeMath or MathML. The
# input is parsed with Plurimath::Math.parse, written to every target with
# Formula#to_<target>, and the output is read back with Plurimath::Math.parse.
# A target is lossless when the formula read back is == to the formula the
# input parsed to; otherwise the case records the loss, worked out from the
# two formulas. An input that does not parse is recorded as a refusal for
# every target. Nothing here states an expectation by hand: every output,
# lossless flag and loss comes from running the installed plurimath.
#
# The cases run once per XML engine (Ox, then Oga) and the script stops
# without writing anything when the engines disagree.
#
# Usage:
#
#   bundle exec ruby scripts/roundtrip_cases.rb --out DIR [--producer FILE]
#
# --producer writes the producer block for the generation's provenance.yaml
# (repository, commit, generator checksum, environment); it needs a clean
# checkout. The output is deterministic: same commit, same bytes.

require "digest"
require "fileutils"
require "open3"
require "yaml"
require_relative "../lib/plurimath"
require "plurimath/xml_engine/oga"

# Cross-language uncertainty round-trip cases.
module RoundtripCases
  ROOT = File.expand_path("..", __dir__)
  REPOSITORY = "https://github.com/plurimath/plurimath"
  SCHEMA = "plurimath-stage/roundtrip/1"
  HEADER = "# Written by plurimath scripts/roundtrip_cases.rb. Do not edit.\n"
  DOCUMENT = "plurimath docs/uncertainty.adoc"
  ASCIIMATH_DOCUMENT = "plurimath docs/asciimath.adoc"
  TARGETS = %w[asciimath unicode mathml omml].freeze
  WRITERS = { "asciimath" => :to_asciimath, "unicode" => :to_unicodemath,
              "mathml" => :to_mathml, "omml" => :to_omml }.freeze
  LOCALIZED = %w[asciimath unicode].freeze
  ENGINES = {
    "ox" => [Plurimath::XmlEngine::OxEngine, :ox],
    "oga" => [Plurimath::XmlEngine::Oga, :oga],
  }.freeze

  MATRIX = "Round-trip matrix"
  ASCIIMATH = "Marker grammars / AsciiMath"
  UNICODE = "Marker grammars / UnicodeMath"
  MATHML = "Marker grammars / MathML"
  UNITS = "The model / Units"
  ERRORS = "Errors"

  MATHML_OPEN = '<math xmlns="http://www.w3.org/1998/Math/MathML" ' \
                'display="block"><mstyle displaystyle="true">'
  MATHML_CLOSE = "</mstyle></math>"

  # [group, description, cases]; each case is [id, language, input,
  # options, [document, section]].
  GROUPS = [
    ["asciimath-standard",
     "Standard uncertainty calls (ustd), absolute and concise, read from " \
     "AsciiMath.",
     [["absolute", "asciimath", "ustd(1.230, 0.004)", {}, [MATRIX]],
      ["concise", "asciimath", "ustd(1.230(4))", {}, [MATRIX]],
      ["concise-long", "asciimath", "ustd(100.02147(35))", {}, [MATRIX]],
      ["negative", "asciimath", "ustd(-1.230, 0.004)", {}, [MATRIX]],
      ["negative-concise", "asciimath", "ustd(-1.230(4))", {}, [MATRIX]],
      ["zero-magnitude", "asciimath", "ustd(5, 0)", {}, [MATRIX]]]],
    ["asciimath-expanded",
     "Expanded uncertainty calls (uexp) with and without a coverage " \
     "probability, read from AsciiMath.",
     [["k", "asciimath", "uexp(10.0, 0.3, 2)", {}, [MATRIX]],
      ["k-p", "asciimath", "uexp(10.0, 0.3, 2, 0.95)", {}, [MATRIX]],
      ["negative", "asciimath", "uexp(-10.0, 0.3, 2)", {}, [MATRIX]]]],
    ["asciimath-coverage-interval",
     "Coverage interval calls (ucov) with each interval choice, read from " \
     "AsciiMath.",
     [["unspecified", "asciimath", "ucov(1.024, 0.983, 1.088, 0.95)", {},
       [MATRIX]],
      ["shortest", "asciimath", "ucov(1.024, 0.983, 1.088, 0.95, shortest)",
       {}, [MATRIX]],
      ["symmetric", "asciimath",
       "ucov(1.024, 0.983, 1.088, 0.95, symmetric)", {}, [MATRIX]],
      ["negative", "asciimath", "ucov(-1.024, 0.983, 1.088, 0.95)", {},
       [MATRIX]]]],
    ["asciimath-shared-exponent",
     "Calls with a shared decimal exponent. The exponent is applied to the " \
     "decimal text on reading, so every writer emits the shifted numbers.",
     [["standard", "asciimath", "ustd((3.85, 0.23)e4)", {},
       [ASCIIMATH_DOCUMENT, "Shared exponents"]],
      ["concise", "asciimath", "ustd(680(41)e-3)", {},
       [ASCIIMATH_DOCUMENT, "Shared exponents"]],
      ["expanded", "asciimath", "uexp((3.85, 0.23)e+4, 2, 0.95)", {},
       [ASCIIMATH_DOCUMENT, "Shared exponents"]],
      ["interval", "asciimath",
       "ucov((1.024, 0.983, 1.088)e-3, 0.95, shortest)", {},
       [ASCIIMATH_DOCUMENT, "Shared exponents"]]]],
    ["asciimath-units",
     "Calls with a UnitsML unit. MathML, OMML and UnicodeMath read the unit " \
     "back as its rendered formula, not as a Unitsml node.",
     [["expanded-g", "asciimath",
       'uexp(100.02147, 0.00079, 2, "unitsml(g)")', {}, [UNITS]],
      ["standard-kg", "asciimath", 'ustd(1.2, 0.1, "unitsml(kg)")', {},
       [UNITS]],
      ["standard-m-per-s", "asciimath", 'ustd(1.2, 0.1, "unitsml(m*s^-1)")',
       {}, [UNITS]],
      ["standard-kg-m2", "asciimath", 'ustd(1.2, 0.1, "unitsml(kg*m^2)")',
       {}, [UNITS]],
      ["standard-um", "asciimath", 'ustd(1.2, 0.1, "unitsml(um)")', {},
       [UNITS]],
      ["concise-g", "asciimath", 'ustd(1.230(4), "unitsml(g)")', {},
       [UNITS]],
      ["interval-m", "asciimath",
       'ucov(1.024, 0.983, 1.088, 0.95, shortest, "unitsml(m)")', {},
       [UNITS]]]],
    ["asciimath-locale",
     "AsciiMath calls read under a locale whose decimal mark is a comma. " \
     "The calls always use '.'; a comma before a digit is refused.",
     [["fr-dot", "asciimath", "ustd(1.230, 0.004)", { "locale" => "fr" },
       [ASCIIMATH_DOCUMENT, "Locale and decimal commas"]],
      ["fr-comma", "asciimath", "ustd(1,5)", { "locale" => "fr" },
       [ASCIIMATH_DOCUMENT, "Locale and decimal commas"]],
      ["fr-comma-pair", "asciimath", "ustd(1,230, 0,004)",
       { "locale" => "fr" },
       [ASCIIMATH_DOCUMENT, "Locale and decimal commas"]]]],
    ["asciimath-invalid",
     "Calls that match the call grammar but are not a valid result.",
     [["zero-k", "asciimath", "uexp(1.0, 0.3, 0, 0.95)", {}, [ERRORS]],
      ["reversed-interval", "asciimath", "ucov(1.0, 2.0, 1.5, 0.95)", {},
       [ERRORS]]]],
    ["unicode-markers",
     "UnicodeMath intent forms, read from UnicodeMath, including units " \
     "written as \\mup and \\mup\"...\".",
     [["standard", "unicode",
       'ⓘ("standard-uncertainty(1.230,0.004)"1.230(0.004))', {}, [UNICODE]],
      ["concise", "unicode",
       'ⓘ("standard-uncertainty:concise(1.230,0.004)"1.230(4))', {},
       [UNICODE]],
      ["expanded-p", "unicode",
       'ⓘ("expanded-uncertainty(10.0,0.3,2,0.95)"(10.0±0.3), k=2, p=0.95)',
       {}, [UNICODE]],
      ["expanded-spaced", "unicode",
       'ⓘ("expanded-uncertainty(10.0,0.3,2)"(10.0 ± 0.3), k=2)', {},
       [UNICODE]],
      ["interval-shortest", "unicode",
       'ⓘ("coverage-interval:shortest(1.024,0.983,1.088,0.95)"' \
       "1.024, [0.983, 1.088], p=0.95)", {}, [UNICODE]],
      ["negative", "unicode",
       'ⓘ("standard-uncertainty(-1.230,0.004)"〖-1.230〗(0.004))', {},
       [UNICODE]],
      ["unit-g", "unicode",
       'ⓘ("expanded-uncertainty(100.02147,0.00079,2,$unit)"' \
       '(100.02147±0.00079)ⓐ(unit \mupg), k=2)', {}, [MATRIX]],
      ["unit-kg", "unicode",
       'ⓘ("standard-uncertainty(1.2,0.1,$unit)"1.2(0.1)ⓐ(unit \mupkg))',
       {}, [MATRIX]],
      ["unit-kg-quoted", "unicode",
       'ⓘ("standard-uncertainty(1.2,0.1,$unit)"1.2(0.1)ⓐ(unit \mup"kg"))',
       {}, [MATRIX]],
      ["unit-m-per-s", "unicode",
       'ⓘ("standard-uncertainty(1.2,0.1,$unit)"' \
       '1.2(0.1)ⓐ(unit \mupm⋅\mups^(-1)))', {}, [MATRIX]],
      ["unit-um", "unicode",
       'ⓘ("standard-uncertainty(1.2,0.1,$unit)"1.2(0.1)ⓐ(unit \mupµm))',
       {}, [MATRIX]],
      ["unit-kg-m2", "unicode",
       'ⓘ("standard-uncertainty(1.2,0.1,$unit)"' \
       '1.2(0.1)ⓐ(unit \mupkg ⋅ \mupm^(2)))', {}, [MATRIX]]]],
    ["mathml-markers",
     "MathML mrow intent forms, read from MathML.",
     [["standard", "mathml",
       "#{MATHML_OPEN}<mrow intent=\"standard-uncertainty(1.230,0.004)\">" \
       "<mn>1.230</mn><mrow><mo>(</mo><mn>0.004</mn><mo>)</mo></mrow>" \
       "</mrow>#{MATHML_CLOSE}", {}, [MATHML]],
      ["concise", "mathml",
       "#{MATHML_OPEN}<mrow intent=\"standard-uncertainty:concise" \
       "(1.230,0.004)\"><mn>1.230</mn><mrow><mo>(</mo><mn>4</mn><mo>)</mo>" \
       "</mrow></mrow>#{MATHML_CLOSE}", {}, [MATHML]],
      ["expanded", "mathml",
       "#{MATHML_OPEN}<mrow intent=\"expanded-uncertainty(10.0,0.3,2)\">" \
       "<mrow><mo>(</mo><mn>10.0</mn><mo>&#xb1;</mo><mn>0.3</mn><mo>)</mo>" \
       "</mrow><mo>,</mo><mi>k</mi><mo>=</mo><mn>2</mn></mrow>" \
       "#{MATHML_CLOSE}", {}, [MATHML]],
      ["unit-kg", "mathml",
       "#{MATHML_OPEN}<mrow intent=\"standard-uncertainty(1.2,0.1,$unit)\">" \
       "<mn>1.2</mn><mrow><mo>(</mo><mn>0.1</mn><mo>)</mo></mrow>" \
       "<mrow arg=\"unit\"><mi mathvariant=\"normal\">kg</mi></mrow></mrow>" \
       "#{MATHML_CLOSE}", {}, [MATRIX]],
      ["unit-kg-m2", "mathml",
       "#{MATHML_OPEN}<mrow intent=\"standard-uncertainty(1.2,0.1,$unit)\">" \
       "<mn>1.2</mn><mrow><mo>(</mo><mn>0.1</mn><mo>)</mo></mrow>" \
       "<mo rspace=\"thickmathspace\">&#x2062;</mo><mrow arg=\"unit\">" \
       "<mstyle mathvariant=\"normal\"><mi>kg</mi></mstyle>" \
       "<mo>&#x22c5;</mo><msup><mstyle mathvariant=\"normal\"><mi>m</mi>" \
       "</mstyle><mn>2</mn></msup></mrow></mrow>#{MATHML_CLOSE}", {},
       [MATRIX]]]],
  ].freeze

  module_function

  # Canonical tagged form (testsuite docs/tree-parity-contract.adoc) of the
  # parsed model, when every field has a declared encoding here; nil when
  # it has not (for example a unit read back as a rendered formula).
  def model(formula)
    nodes = formula.value
    return unless nodes.size == 1 && nodes.first.is_a?(uncertainty_class)

    tagged(nodes.first)
  rescue KeyError
    nil
  end

  def uncertainty_class
    Plurimath::Math::Function::Uncertainty
  end

  UNCERTAINTY_FIELDS = %i[value category magnitude coverage_factor
                          coverage_probability lower upper interval_kind
                          notation unit].freeze
  NUMBER_FIELDS = %i[value mini_sub_sized mini_sup_sized base].freeze

  def tagged(value)
    case value
    when nil then { "nil" => true }
    when true, false then { "bool" => value }
    when Symbol then { "sym" => value.to_s }
    when String then { "str" => value }
    when uncertainty_class then node(value, UNCERTAINTY_FIELDS)
    when Plurimath::Math::Number then node(value, NUMBER_FIELDS)
    when Plurimath::Math::Function::Unitsml then node(value, %i[text])
    else raise KeyError, "no declared encoding for #{value.class}"
    end
  end

  def node(value, fields)
    { "node" => value.class.name,
      "fields" => fields.map do |field|
        [field.to_s, tagged(value.public_send(field))]
      end }
  end

  def parse(input, language, options)
    Plurimath::Math.parse(input, language.to_sym, **options)
  end

  def symbolized(options)
    options.to_h { |key, value| [key.to_sym, value] }
  end

  def target(formula, language, options)
    output = formula.public_send(WRITERS.fetch(language))
    read_options = LOCALIZED.include?(language) ? options : {}
    back = parse(output, language, read_options)
    result = { "output" => output, "lossless" => back == formula }
    result["loss"] = loss(formula, back) unless result["lossless"]
    result
  rescue Plurimath::Math::ParseError => e
    { "output" => output, "lossless" => false,
      "loss" => "reading the output back raises #{e.class.name}" }
  end

  # What differs between the formula written and the formula read back.
  def loss(written, back)
    before = written.value
    after = back.value
    unless before.size == after.size
      return "reads back as #{describe(after)} instead of #{describe(before)}"
    end

    before.zip(after).each_with_index.filter_map do |(old, new), index|
      next if old == new

      node_loss(old, new, index)
    end.join("; ")
  end

  def node_loss(old, new, index)
    unless old.is_a?(uncertainty_class) && new.is_a?(uncertainty_class)
      return "node #{index}: #{old.class.name} reads back as " \
             "#{new.class.name}"
    end

    UNCERTAINTY_FIELDS.filter_map do |field|
      was = old.public_send(field)
      now = new.public_send(field)
      next if was == now

      "#{field}: #{field_text(was)} reads back as #{field_text(now)}"
    end.join("; ")
  end

  def field_text(value)
    case value
    when nil then "nil"
    when Symbol then ":#{value}"
    when Plurimath::Math::Number then value.value.inspect
    when Plurimath::Math::Function::Unitsml
      "Unitsml #{value.text.inspect}"
    when Plurimath::Math::Formula
      "rendered formula #{value.to_asciimath.inspect}"
    else value.class.name
    end
  end

  def describe(nodes)
    names = nodes.map { |node| node.class.name.split("::").last }
    "#{nodes.size} node(s) (#{names.join(', ')})"
  end

  def expected(input, language, options)
    formula = parse(input, language, symbolized(options))
    targets = TARGETS.to_h do |name|
      [name, target(formula, name, symbolized(options))]
    end
    [model(formula), targets]
  rescue Plurimath::Math::ParseError
    [nil, TARGETS.to_h do |name|
      [name, { "refusal" => { "category" => "parse_error",
                              "byte_offset" => nil } }]
    end]
  end

  def row(group, entry)
    id, language, input, options, reference = entry
    section = reference.last
    document = reference.size == 2 ? reference.first : DOCUMENT
    model, targets = expected(input, language, options)
    data = { "id" => "#{group}.#{id}",
             "spec" => { "document" => document, "section" => section },
             "source" => { "language" => language, "input" => input },
             "options" => options }
    data["model"] = model if model
    data.merge("expected" => targets)
  end

  def payload(group, description, entries)
    { "schema" => SCHEMA, "group" => group,
      "description" => "#{description} Each target is written by " \
                       "Formula#to_<target> and read back with " \
                       "Plurimath::Math.parse (with the case's options " \
                       "for AsciiMath and UnicodeMath); lossless means " \
                       "the formula read back is == to the one the input " \
                       "parsed to. model, where present, is the single " \
                       "Uncertainty node the input parses to.",
      "cases" => entries.map { |entry| row(group, entry) } }
  end

  def with_engine(name)
    engine, adapter = ENGINES.fetch(name)
    Plurimath.load_mml
    saved = [Plurimath.xml_engine, Mml::V4::Configuration.adapter]
    Plurimath.xml_engine = engine
    Mml::V4::Configuration.adapter = adapter
    yield
  ensure
    Plurimath.xml_engine = saved[0]
    Mml::V4::Configuration.adapter = saved[1]
  end

  # The payloads, computed on every engine; raises when they disagree.
  def payloads
    runs = ENGINES.keys.map do |name|
      with_engine(name) do
        GROUPS.map { |group, text, entries| payload(group, text, entries) }
      end
    end
    first = runs.first
    runs.each_with_index do |run, index|
      next if run == first

      raise "the #{ENGINES.keys[index]} engine writes different payloads " \
            "from the #{ENGINES.keys.first} engine"
    end
    first
  end

  def git(*command)
    output, status = Open3.capture2("git", "-C", ROOT, *command)
    raise "git #{command.join(' ')} failed" unless status.success?

    output
  end

  def tracked(relative, commit)
    { "repository" => REPOSITORY, "commit" => commit, "path" => relative,
      "sha256" => Digest::SHA256.file(File.join(ROOT, relative)).hexdigest }
  end

  def lockfile
    specs = Bundler.load.specs.sort_by(&:name)
    { "path" => "Gemfile.lock", "committed" => false,
      "bundler" => Bundler::VERSION,
      "resolved" => specs.to_h { |spec| [spec.name, spec.version.to_s] } }
  end

  def dependencies
    specs = Bundler.load.specs.to_h { |spec| [spec.name, spec] }
    gemspec = Gem::Specification.load(File.join(ROOT, "plurimath.gemspec"))
    gemspec.runtime_dependencies.map(&:name).sort.to_h do |name|
      [name, specs.fetch(name).version.to_s]
    end
  end

  def producer
    raise "--producer needs a clean checkout" unless
      git("status", "--porcelain").empty?

    commit = git("rev-parse", "HEAD").strip
    { "kind" => "legacy-oracle", "repository" => REPOSITORY,
      "commit" => commit, "version" => Plurimath::VERSION,
      "generator" => tracked("scripts/roundtrip_cases.rb", commit),
      "inputs" => [],
      "environment" => {
        "ruby" => { "engine" => RUBY_ENGINE, "version" => RUBY_VERSION },
        "xml_engine" => ENGINES.values.map { |engine, _| engine.name }
          .join(", "),
        "lockfile" => lockfile, "dependencies" => dependencies,
        "compiler" => nil, "binding" => nil, "lml" => nil
      },
      "semantic_boundary" => "roundtrip",
      "configuration" => {
        "entry_point" => "Plurimath::Math.parse, Formula#to_<target>",
        "targets" => TARGETS, "xml_engines" => ENGINES.keys
      } }
  end

  def options(argv)
    opts = {}
    args = argv.dup
    until args.empty?
      case (arg = args.shift)
      when "--out" then opts[:out] = File.expand_path(args.shift.to_s)
      when "--producer" then opts[:producer] = File.expand_path(args.shift.to_s)
      else abort "unknown argument #{arg.inspect}"
      end
    end
    abort "usage: #{$PROGRAM_NAME} --out DIR [--producer FILE]" unless
      opts[:out]
    opts
  end

  def run(argv)
    opts = options(argv)
    data = payloads
    block = (producer if opts[:producer])
    FileUtils.mkdir_p(opts[:out])
    data.each do |payload|
      File.write(File.join(opts[:out], "#{payload['group']}.yaml"),
                 HEADER + YAML.dump(payload))
    end
    File.write(opts[:producer], YAML.dump(block)) if block
    rows = data.sum { |payload| payload["cases"].size }
    warn "wrote #{data.size} payload(s), #{rows} case(s) to #{opts[:out]}"
  end
end

RoundtripCases.run(ARGV) if $PROGRAM_NAME == __FILE__
