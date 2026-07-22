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

    # The glyph itself, wrapped in a Formula for rendering.
    def example_formula
      Math::Formula.new([new])
    end

    # Catalogued when the symbol renders a glyph — this excludes the abstract
    # bases (Symbol, Paren) that render nothing.
    def documented?
      formula = example_formula
      !formula.to_asciimath.to_s.strip.empty? ||
        !formula.to_latex.to_s.strip.empty?
    end

    # The YAML-ready entry: the glyph's name, type, and rendering in each format.
    # Leaner than a function entry — a symbol carries no description or reference.
    def catalog_entry
      formula = example_formula
      {
        "name" => catalog_name,
        "type" => catalog_type.to_s,
        "asciimath" => formula.to_asciimath,
        "latexmath" => formula.to_latex,
        "mathml" => formula.to_mathml,
        "omml" => formula.to_omml,
      }
    end
  end
end
