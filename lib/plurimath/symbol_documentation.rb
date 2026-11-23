# frozen_string_literal: true

module Plurimath
  # Per-symbol metadata for the catalog (see Plurimath::Catalog), extended into
  # Symbols::Symbol. Symbols are documented differently from functions: a symbol
  # is an atomic glyph with no arguments, so it needs no hand-authored
  # description, reference, or example — its four renderings ARE its
  # documentation. Everything here is derived, so every concrete symbol is
  # catalogued without per-class declarations. (Functions, by contrast, each
  # explain themselves via the separate Plurimath::Documentation.)
  module SymbolDocumentation
    autoload :CatalogMethods, "plurimath/symbol_documentation/catalog_methods"

    # Classes retain the metadata API while conversion leaves its implementation
    # unloaded. Include on the shared module so existing classes, descendants and
    # overrides calling super all see the same method lookup chain.
    %i[catalog_name catalog_type catalog_kind catalog_arity example_formula documented? catalog_entry].each do |method|
      define_method(method) do
        SymbolDocumentation.include(CatalogMethods) unless SymbolDocumentation < CatalogMethods
        super()
      end
    end
  end
end
