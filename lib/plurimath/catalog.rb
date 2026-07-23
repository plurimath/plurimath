# frozen_string_literal: true

module Plurimath
  # The documented symbol/function catalog that plurimath.org generates its
  # reference pages from. Each entry carries the metadata plus the example
  # rendered to AsciiMath, LaTeX, MathML and OMML — see Plurimath::Documentation.
  #
  #   Plurimath::Catalog.entries.each do |e|
  #     File.write("_data/functions/#{e['name']}.yaml", e.to_yaml)
  #   end
  module Catalog
    module_function

    # Every documented class, sorted by catalog name for stable output.
    def classes
      ensure_documentable_classes_loaded
      documentable_bases
        .flat_map(&:descendants)
        .uniq
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

    # Base classes whose documented descendants are catalogued. Grows as later
    # PRs document the other arities and the symbols.
    def documentable_bases
      [Math::Function::TernaryFunction]
    end

    # descendants only sees loaded classes, so require the source files of every
    # documentable base before enumerating. Only the function tree is loaded
    # today; once Symbols::Symbol becomes documentable this widens to match.
    # Memoized so repeated catalog calls don't re-glob the tree.
    def ensure_documentable_classes_loaded
      return if @documentable_classes_loaded

      pattern = File.join(__dir__, "math", "function", "**", "*.rb")
      Dir.glob(pattern).each { |file| require file }
      @documentable_classes_loaded = true
    end

    private_class_method :documentable_bases, :ensure_documentable_classes_loaded
  end
end
