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
    # Slug for the /symbols/<name>/ page and YAML filename: Alpha -> "alpha".
    def catalog_name
      name.split("::").last.downcase
    end

    def catalog_type
      :symbol
    end

    def catalog_kind
      :symbol
    end

    def catalog_arity
      nil
    end

    # The glyph itself, wrapped in a Formula for rendering.
    def example_formula
      Math::Formula.new([new])
    end

    # Anonymous subclasses have no stable catalog name and are excluded.
    # Catalogued when the symbol is a concrete glyph — i.e. not one of the
    # abstract bases (Symbol, Paren), which exist only to be subclassed. Checked
    # by identity rather than by rendering: cheaper across the ~1,459 symbols and
    # independent of which formats a given glyph happens to serialize to.
    def documented?
      !name.nil? && ![Math::Symbols::Symbol, Math::Symbols::Paren].include?(self)
    end

    # The YAML-ready entry: the glyph's name, type, and rendering in each format.
    # Leaner than a function entry — a symbol carries no description or reference.
    def catalog_entry
      limitations = const_defined?(:CATALOG_FORMAT_LIMITATIONS, false) ?
        const_get(:CATALOG_FORMAT_LIMITATIONS, false) : {}
      Catalog::Entry.build(
        name: catalog_name, type: catalog_type, kind: catalog_kind,
        arity: catalog_arity, formula: example_formula, limitations: limitations
      )
    end
  end
end
