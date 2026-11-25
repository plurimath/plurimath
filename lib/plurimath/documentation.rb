# frozen_string_literal: true

module Plurimath
  # Per-class documentation metadata for the function side of the catalog
  # (see Plurimath::Catalog, which powers the plurimath.org "Functions" and
  # "Symbols" pages). A documentable base class extends this module —
  # TernaryFunction, BinaryFunction, UnaryFunction, Table, and Nary — and every
  # descendant then inherits the shared, derivable machinery (name, type, the
  # four renderings) while each concrete class "explains itself" with three
  # declarations: DESCRIPTION, REFERENCE, and an EXAMPLE lambda. Table and Nary
  # are themselves documented (the /functions/table and /functions/n-ary pages),
  # not just bases. Symbols are documented separately by
  # Plurimath::SymbolDocumentation, which derives everything.
  module Documentation
    autoload :CatalogMethods, "plurimath/documentation/catalog_methods"

    # Classes retain the metadata API while conversion leaves its implementation
    # unloaded. Include on the shared module so existing classes, descendants and
    # overrides calling super all see the same method lookup chain.
    %i[
      catalog_name catalog_type catalog_kind catalog_arity description reference
      example_formula documented? catalog_entry
    ].each do |method|
      define_method(method) do
        Documentation.include(CatalogMethods) unless Documentation < CatalogMethods
        super()
      end
    end
  end
end
