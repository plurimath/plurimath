# frozen_string_literal: true

# Regenerates the generated regions of docs/core-model-contract.adoc: the
# inventory of every Plurimath::Math class, read from the loaded code on the
# checked-out revision.
#
# Usage, from the Plurimath checkout:
#
#   bundle exec ruby scripts/docs/core_inventory.rb [--check]
#
# Without --check it rewrites the regions between
# "// BEGIN GENERATED <name>" and "// END GENERATED <name>" in
# docs/core-model-contract.adoc. With --check it writes nothing and exits 1
# when the file differs from what it would write. The output depends only on
# the source tree, never on time or local paths.
#
# What is measured, and how:
#
# * Classes: every Class whose name starts with "Plurimath::Math::", after
#   every file under lib/plurimath/math is required.
# * Fields: methods created by attr_accessor, attr_reader or attr_writer. A
#   method counts as a field when its source line is an attr_* call.
# * Constructor: the owner of #initialize and its parameters, with default
#   expressions copied from the source by Prism.
# * Public methods: public_instance_methods(false), minus the field methods.
# * Writers: the six per-format writer methods listed in WRITERS.
# * Parser-only methods: public methods defined under lib/plurimath/math whose
#   only call sites in lib/ are in the in-tree LaTeX and UnicodeMath layers.

require "prism"

module CoreInventory
  ROOT = File.expand_path("../..", __dir__)
  DOC = File.join(ROOT, "docs/core-model-contract.adoc")
  MATH_DIR = File.join(ROOT, "lib/plurimath/math")

  WRITERS = %i[
    to_asciimath to_latex to_mathml_without_math_tag
    to_omml_without_math_tag to_unicodemath to_html
  ].freeze

  # Directories (under lib/plurimath) that #531 removes.
  PARSER_LAYERS = %w[latex unicode_math].freeze

  FAMILY_ORDER = %w[
    core formula function-unary function-binary function-ternary
    function-nary function-table uncertainty-unitsml symbols-symbol
    symbols-paren support
  ].freeze

  MARKS = %w[stays-core removed-by-531 support].freeze
  SYMBOL_FAMILIES = %w[symbols-symbol symbols-paren].freeze
  BASE_SYMBOLS = %w[Plurimath::Math::Symbols::Symbol Plurimath::Math::Symbols::Paren].freeze

  FAMILY_TITLES = {
    "core" => "Core and Number",
    "formula" => "Formula",
    "function-unary" => "Function, unary",
    "function-binary" => "Function, binary",
    "function-ternary" => "Function, ternary",
    "function-nary" => "Function, n-ary",
    "function-table" => "Function, table",
    "uncertainty-unitsml" => "Uncertainty and UnitsML nodes",
    "symbols-symbol" => "Symbols",
    "symbols-paren" => "Symbols, parentheses",
    "support" => "Support (not tree nodes)",
  }.freeze

  class Error < StandardError; end

  module_function

  def load_tree
    $LOAD_PATH.unshift(File.join(ROOT, "lib"))
    require "plurimath"
    Dir.glob(File.join(MATH_DIR, "**/*.rb")).each { |file| require file }
  end

  def m
    Plurimath::Math
  end

  def classes
    @classes ||= ObjectSpace.each_object(Class)
      .select { |k| k.name&.start_with?("Plurimath::Math::") }
      .sort_by(&:name)
  end

  def short(klass)
    klass.name.delete_prefix("Plurimath::Math::")
  end

  def node?(klass)
    klass <= m::Core
  end

  def family(klass)
    f = m::Function
    s = m::Symbols
    return "support" unless node?(klass)
    return "formula" if klass <= m::Formula
    return "function-unary" if klass <= f::UnaryFunction
    return "function-binary" if klass <= f::BinaryFunction
    return "function-ternary" if klass <= f::TernaryFunction
    return "function-nary" if klass <= f::Nary
    return "function-table" if klass <= f::Table
    return "uncertainty-unitsml" if [f::Uncertainty, f::Unitsml].include?(klass)
    return "symbols-paren" if klass <= s::Paren
    return "symbols-symbol" if klass <= s::Symbol

    "core"
  end

  def source_lines(file)
    @source_lines ||= {}
    @source_lines[file] ||= File.readlines(file)
  end

  def relative(file)
    file.delete_prefix("#{ROOT}/")
  end

  def field_method?(klass, name)
    file, line = klass.instance_method(name).source_location
    return false unless file && line

    source_lines(file)[line - 1].to_s.match?(/\battr_(accessor|reader|writer)\b/)
  end

  # Fields declared by this class itself (not inherited).
  def own_fields(klass)
    @own_fields ||= {}
    @own_fields[klass] ||= begin
      names = klass.public_instance_methods(false) +
        klass.private_instance_methods(false)
      names.select { |n| field_method?(klass, n) }
        .map { |n| n.to_s.delete_suffix("=") }.uniq.sort
    end
  end

  def fields(klass)
    klass.ancestors.select { |a| a.is_a?(Class) && a.name&.start_with?("Plurimath::Math::") }
      .flat_map { |a| own_fields(a) }.uniq.sort
  end

  def field_owner(klass)
    klass.ancestors.find do |a|
      a.is_a?(Class) && a.name&.start_with?("Plurimath::Math::") &&
        !own_fields(a).empty?
    end
  end

  def own_methods(klass)
    @own_methods ||= {}
    @own_methods[klass] ||= begin
      fields = own_fields(klass)
      klass.public_instance_methods(false)
        .reject { |n| fields.include?(n.to_s.delete_suffix("=")) }
        .map(&:to_s).sort
    end
  end

  def constructor_owner(klass)
    owner = klass.instance_method(:initialize).owner
    owner.name&.start_with?("Plurimath::Math::") ? owner : nil
  end

  def def_node(file, line)
    @parsed ||= {}
    @parsed[file] ||= Prism.parse_file(file).value
    found = nil
    queue = [@parsed[file]]
    until queue.empty?
      node = queue.shift
      if node.is_a?(Prism::DefNode) && node.name == :initialize &&
          node.location.start_line == line
        found = node
        break
      end
      queue.concat(node.compact_child_nodes)
    end
    found
  end

  def signature(klass)
    owner = constructor_owner(klass)
    return "(Object default)" unless owner

    file, line = owner.instance_method(:initialize).source_location
    node = def_node(file, line)
    raise Error, "no def initialize at #{relative(file)}:#{line}" unless node

    params = node.parameters
    return "()" unless params

    parts = params.requireds.map(&:slice)
    parts.concat(params.optionals.map { |p| "#{p.name} = #{p.value.slice}" })
    parts << params.rest.slice if params.rest
    parts.concat(params.posts.map(&:slice))
    parts.concat(params.keywords.map { |p| keyword(p) })
    parts << params.keyword_rest.slice if params.keyword_rest
    parts << params.block.slice if params.block
    "(#{parts.join(', ').gsub(/\s+/, ' ')})"
  end

  def keyword(param)
    return "#{param.name}:" unless param.is_a?(Prism::OptionalKeywordParameterNode)

    "#{param.name}: #{param.value.slice}"
  end

  def writers(klass)
    WRITERS.select { |w| klass.method_defined?(w) }
  end

  # stays-core: a tree node that carries at least one writer, plus the
  # abstract root Core. removed-by-531: a tree node with no writer at all,
  # so it cannot reach any output and only serves the parser layers.
  # support: not a tree node.
  def mark(klass)
    return "support" unless node?(klass)
    return "stays-core" if klass == m::Core || !writers(klass).empty?

    "removed-by-531"
  end

  def missing_writers(klass)
    return [] unless node?(klass) && klass != m::Core

    WRITERS - writers(klass)
  end

  def lib_files
    @lib_files ||= Dir.glob(File.join(ROOT, "lib/**/*.rb"))
      .to_h { |f| [relative(f), File.read(f)] }
  end

  def layer(path)
    path.delete_prefix("lib/plurimath/").split("/").first.delete_suffix(".rb")
  end

  # Public methods defined on tree nodes whose only call sites are in the
  # parser layers #531 removes.
  def parser_only_methods
    node_classes = classes.select { |k| node?(k) }
    names = node_classes.flat_map { |k| own_methods(k) }.uniq.sort
    names -= Object.public_instance_methods.map(&:to_s)
    names.filter_map do |name|
      pattern = /(?:\.|&\.|send\(:)#{Regexp.escape(name)}(?![\w?!=])/
      layers = lib_files.select { |_, s| s.match?(pattern) }.keys.map { |f| layer(f) }.uniq
      next if layers.empty? || !(layers - PARSER_LAYERS).empty?

      owners = node_classes.select { |k| own_methods(k).include?(name) }.map { |k| short(k) }
      [name, owners, layers.sort]
    end
  end

  def input_table_counts
    symbols = classes.select { |k| k <= m::Symbols::Symbol && k != m::Symbols::Symbol }
    langs = symbols.flat_map { |k| k::INPUT.keys }.uniq.sort
    langs.to_h { |lang| [lang, symbols.count { |k| k::INPUT.key?(lang) }] }
      .merge(total: symbols.size,
             only_parser: symbols.count { |k| !k::INPUT.empty? && (k::INPUT.keys - %i[latex unicodemath]).empty? })
  end

  # Tables use "¦" as the cell separator, so cell text (which may hold "|",
  # as in Vmatrix's defaults) needs no escaping. A cell that holds the
  # separator itself is refused.
  SEPARATOR = "\u00a6"

  def table_start(cols)
    "[cols=\"#{cols}\",options=\"header\",separator=#{SEPARATOR}]\n|===\n"
  end

  def row(cells)
    cells = cells.map(&:to_s)
    bad = cells.find { |c| c.include?(SEPARATOR) }
    raise Error, "cell contains the table separator: #{bad}" if bad

    "#{SEPARATOR} #{cells.join(" #{SEPARATOR} ")}\n"
  end

  def code(text)
    text.to_s.empty? ? "-" : "`+#{text}+`"
  end

  def list(items)
    items.empty? ? "-" : items.map { |i| code(i) }.join(", ")
  end

  # --- generated regions -----------------------------------------------

  def counts_region
    marks = MARKS
    rows = FAMILY_ORDER.map do |fam|
      in_fam = classes.select { |k| family(k) == fam }
      [FAMILY_TITLES.fetch(fam), in_fam.size, *marks.map { |mk| in_fam.count { |k| mark(k) == mk } }]
    end
    totals = ["*Total*", classes.size, *marks.map { |mk| classes.count { |k| mark(k) == mk } }]
    out = +table_start("3,1,1,1,1")
    out << row(["Family", "Classes", *MARKS]) << "\n"
    (rows + [totals]).each { |r| out << row(r) }
    out << "|===\n"
  end

  def bases_region
    owners = classes.select { |k| node?(k) }.filter_map { |k| field_owner(k) }.uniq
    owners += classes.select { |k| node?(k) }.filter_map { |k| constructor_owner(k) }
    owners = owners.uniq.sort_by(&:name)
    out = +table_start("2,3,4,1")
    out << row(["Class", "Own fields", "Constructor", "Classes served"]) << "\n"
    owners.each do |o|
      users = classes.count { |k| node?(k) && (field_owner(k) == o || constructor_owner(k) == o) }
      ctor = constructor_owner(o) == o ? code(signature(o)) : "inherited"
      out << row([code(short(o)), list(own_fields(o)), ctor, users])
    end
    out << "|===\n"
  end

  def constructor_text(klass)
    ctor = constructor_owner(klass)
    return "-" unless ctor
    return code(signature(klass)) if ctor == klass

    "from #{code(short(ctor))}"
  end

  def class_row(klass)
    owner = field_owner(klass)
    [code(short(klass)), FAMILY_TITLES.fetch(family(klass)),
     code(klass.superclass.name.delete_prefix("Plurimath::Math::")),
     owner ? code(short(owner)) : "-", list(own_fields(klass)),
     constructor_text(klass), list(own_methods(klass)),
     list(missing_writers(klass)), mark(klass)]
  end

  def classes_region
    rows = classes.reject { |k| symbol_leaf?(k) }
    out = +table_start("3,2,2,2,2,3,5,2,1")
    out << row(["Class", "Family", "Superclass", "Field owner", "Own fields", "Constructor",
                "Own public methods", "Writers not defined", "Mark"]) << "\n"
    rows.each { |k| out << row(class_row(k)) }
    out << "|===\n"
  end

  def symbol_leaf?(klass)
    SYMBOL_FAMILIES.include?(family(klass)) && !BASE_SYMBOLS.include?(klass.name)
  end

  # Symbols are listed in groups of identical shape: same superclass, own
  # fields, constructor owner, own public methods and mark.
  def symbols_region
    leaves = classes.select { |k| symbol_leaf?(k) }
    groups = leaves.group_by do |k|
      ctor = constructor_owner(k)
      [k.superclass.name, own_fields(k), ctor && short(ctor), own_methods(k), mark(k)]
    end
    out = +""
    groups.sort_by { |key, members| [-members.size, key.inspect] }.each_with_index do |(key, members), i|
      sup, fields, ctor, methods, mk = key
      out << "[%collapsible]\n.Shape #{i + 1}: #{members.size} classes < #{code(sup.delete_prefix('Plurimath::Math::'))}, #{mk}\n====\n"
      out << "Own fields: #{list(fields)}. Constructor: #{ctor ? code(ctor) : '-'}.\n"
      out << "Own public methods: #{list(methods)}.\n\n"
      out << "Classes: #{members.map { |k| short(k).delete_prefix('Symbols::') }.join(', ')}.\n====\n\n"
    end
    out
  end

  def parser_only_region
    out = +table_start("2,3,2")
    out << row(["Method", "Defined on", "Called only from"]) << "\n"
    rows = parser_only_methods
    rows.each do |name, owners, layers|
      out << row([code(name), list(owners), layers.map { |l| "`lib/plurimath/#{l}/`" }.join(", ")])
    end
    out << "|===\n"
    c = input_table_counts
    out << "\nSymbol `INPUT` tables (#{c[:total]} symbol classes):\n\n"
    c.except(:total, :only_parser).each { |lang, n| out << "* `#{lang}`: #{n} classes\n" }
    out << "* only `latex` and/or `unicodemath` keys: #{c[:only_parser]} classes\n"
    out
  end

  REGIONS = {
    "counts" => :counts_region,
    "bases" => :bases_region,
    "classes" => :classes_region,
    "symbols" => :symbols_region,
    "parser-only" => :parser_only_region,
  }.freeze

  def render(text)
    REGIONS.reduce(text) do |doc, (name, meth)|
      pattern = %r{(^// BEGIN GENERATED #{name}\n).*?(^// END GENERATED #{name}\n)}m
      raise Error, "region #{name} not found in #{relative(DOC)}" unless doc.match?(pattern)

      body = public_send(meth)
      doc.sub(pattern) { "#{Regexp.last_match(1)}#{body}#{Regexp.last_match(2)}" }
    end
  end

  def run(argv)
    check = argv.delete("--check")
    raise Error, "unknown arguments: #{argv.join(' ')}" unless argv.empty?

    load_tree
    current = File.read(DOC)
    updated = render(current)
    if check
      return 0 if current == updated

      warn "#{relative(DOC)} is out of date; run scripts/docs/core_inventory.rb"
      return 1
    end
    File.write(DOC, updated) unless current == updated
    0
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    exit CoreInventory.run(ARGV.dup)
  rescue CoreInventory::Error => e
    warn e.message
    exit 2
  end
end
