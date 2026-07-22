# frozen_string_literal: true

module Plurimath
  # The documented symbol/function catalog that plurimath.org generates its
  # reference pages from. Each entry carries a name, a type, and the example
  # rendered to AsciiMath, LaTeX, MathML and OMML; function entries also carry a
  # description and reference. See Plurimath::Documentation (functions) and
  # Plurimath::SymbolDocumentation (symbols).
  #
  #   Plurimath::Catalog.entries.each do |e|
  #     dir = e["type"] == "symbol" ? "symbols" : "functions"
  #     File.write("_data/#{dir}/#{e['name']}.yaml", e.to_yaml)
  #   end
  module Catalog
    module_function

    # Every documented class, sorted by catalog name for stable output.
    def classes
      ensure_documentable_classes_loaded
      documentable_bases
        .flat_map { |base| descendants_of(base) }
        .select(&:documented?)
        .sort_by(&:catalog_name)
    end

    def each(&block)
      classes.each(&block)
    end

    # YAML-ready hashes, one per documented class.
    def entries
      classes.map(&:catalog_entry)
    end

    # Base classes whose documented descendants are catalogued: the function
    # arities and the symbol tree.
    def documentable_bases
      [
        Math::Function::TernaryFunction,
        Math::Function::BinaryFunction,
        Math::Function::UnaryFunction,
        Math::Symbols::Symbol,
      ]
    end

    # descendants only sees loaded classes, so require the source files of every
    # documentable base before enumerating — the function tree and the symbol
    # tree. Memoized so repeated catalog calls don't re-glob.
    def ensure_documentable_classes_loaded
      return if @documentable_classes_loaded

      %w[function symbols].each do |tree|
        pattern = File.join(__dir__, "math", tree, "**", "*.rb")
        Dir.glob(pattern).each { |file| require file }
      end
      @documentable_classes_loaded = true
    end

    # descendants lists only direct subclasses, so collect the whole subtree —
    # nested symbol families (e.g. the Paren delimiters) live one level below
    # their group base.
    def descendants_of(klass)
      Array(klass.descendants)
        .flat_map { |descendant| [descendant, *descendants_of(descendant)] }
    end

    private_class_method :documentable_bases, :ensure_documentable_classes_loaded,
                         :descendants_of
  end
end
