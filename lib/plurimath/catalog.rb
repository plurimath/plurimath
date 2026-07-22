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

    # Every documented class, sorted by catalog name — with catalog type as a
    # tiebreaker, since a symbol and a function can share a name (e.g. `bar`) —
    # for stable, totally-ordered output.
    # descendants_of returns a base's descendants but not the base itself, so
    # each base is enumerated alongside them — otherwise a base that is itself
    # documentable is missed (Table's own `table` page; Nary, which is both
    # documentable and has no descendants). Abstract bases are dropped by
    # documented?: the arity classes declare no example, and the Symbol and
    # Paren bases render nothing.
    def classes
      ensure_documentable_classes_loaded
      documentable_bases
        .flat_map { |base| [base, *descendants_of(base)] }
        .uniq
        .select(&:documented?)
        .sort_by { |klass| [klass.catalog_name, klass.catalog_type.to_s] }
    end

    def each(&block)
      classes.each(&block)
    end

    # YAML-ready hashes, one per documented class.
    def entries
      classes.map(&:catalog_entry)
    end

    # Base classes whose documented descendants (and the bases themselves) are
    # catalogued: the function arities, the table/n-ary bases, and the symbol tree.
    def documentable_bases
      [
        Math::Function::TernaryFunction,
        Math::Function::BinaryFunction,
        Math::Function::UnaryFunction,
        Math::Function::Table,
        Math::Function::Nary,
        Math::Symbols::Symbol,
      ]
    end

    # descendants only sees loaded classes, so require the source files of every
    # documentable base before enumerating — the function tree and the symbol
    # tree. Memoized so repeated catalog calls don't re-glob.
    def ensure_documentable_classes_loaded
      return if @documentable_classes_loaded

      # Dir.glob/require need a filesystem; under Opal the trees are build-loaded,
      # so skip enumeration there rather than crash (mirrors symbols.rb).
      if RUBY_ENGINE != "opal"
        # math/symbols.rb loads the Symbol base (and nested bases) before their
        # subclasses; a raw sorted Dir.glob would require symbols/alpha before
        # symbols/symbol and raise NameError. The function tree loads its bases
        # first, so glob it directly.
        require File.join(__dir__, "math", "symbols")
        Dir.glob(File.join(__dir__, "math", "function", "**", "*.rb")).each do |file|
          require file
        end
      end
      @documentable_classes_loaded = true
    end

    # descendants lists only direct subclasses, so walk the whole subtree —
    # nested families (FontStyle's styles, the Paren delimiters) live below
    # their group base.
    def descendants_of(klass)
      Array(klass.descendants)
        .flat_map { |descendant| [descendant, *descendants_of(descendant)] }
    end

    private_class_method :documentable_bases, :ensure_documentable_classes_loaded,
                         :descendants_of
  end
end
