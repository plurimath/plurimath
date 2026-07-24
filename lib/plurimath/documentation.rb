# frozen_string_literal: true

module Plurimath
  # Per-class documentation metadata for the symbol/function catalog
  # (see Plurimath::Catalog, which powers the plurimath.org "Functions" and
  # "Symbols" pages). A documentable base class extends this module — so far
  # TernaryFunction, BinaryFunction, UnaryFunction, Table, and Nary, with
  # Symbols::Symbol to follow — and every descendant then inherits the shared,
  # derivable machinery (name, type, the four renderings) while each concrete
  # class "explains itself" with three declarations: DESCRIPTION, REFERENCE,
  # and an EXAMPLE lambda. Table and Nary are themselves documented (the
  # /table and /n-ary pages), not just bases for their descendants.
  module Documentation
    # Slug for the /functions/<name>/ page and YAML filename, matching the
    # lowercased, separator-free convention the site already uses:
    # Sum -> "sum", PowerBase -> "powerbase". A class whose page slug can't be
    # derived from its name declares CATALOG_NAME to override it (Nary ->
    # "n-ary").
    def catalog_name
      declared_constant(:CATALOG_NAME) || name.split("::").last.downcase
    end

    # :unary / :binary / :ternary / :symbol — declared once per base and
    # inherited by every descendant.
    def catalog_type
      declared_constant(:CATALOG_TYPE, inherit: true)
    end

    def description
      declared_constant(:DESCRIPTION)
    end

    def reference
      declared_constant(:REFERENCE)
    end

    # Builds the example fresh from the class's EXAMPLE lambda. Because EXAMPLE
    # is deferred, nothing is constructed — and no sibling class referenced —
    # until the catalog is generated. nil when the class declares no example.
    def example_formula
      block = declared_constant(:EXAMPLE)
      return unless block

      result = instance_exec(&block)
      case result
      when Math::Formula then result   # lambda already built one — don't re-wrap
      when Array then expr(*result)    # splat a multi-part example
      else expr(result)                # wrap a bare node
      end
    end

    # Catalogued only when a class carries the full three-declaration contract —
    # description, reference and example — so partially-documented classes never
    # leak into the output.
    def documented?
      !description.nil? && !reference.nil? && !declared_constant(:EXAMPLE).nil?
    end

    # The YAML-ready entry the docs consume: metadata plus the example rendered
    # to every target format.
    def catalog_entry
      formula = example_formula
      {
        "name" => catalog_name,
        "type" => catalog_type&.to_s,
        "description" => description,
        "reference" => reference,
        "asciimath" => formula&.to_asciimath,
        "latexmath" => formula&.to_latex,
        "mathml" => formula&.to_mathml,
        "omml" => formula&.to_omml,
      }
    end

    private

    # Reads an own constant (or an inherited one when inherit: true), else nil.
    def declared_constant(name, inherit: false)
      const_get(name, inherit) if const_defined?(name, inherit)
    end

    # Constructor helpers: sym() keeps the EXAMPLE lambda bodies readable, and
    # expr() wraps each example result in a Formula (used by example_formula and
    # available to lambdas that build multi-part examples).
    def sym(value)
      Math::Symbols::Symbol.new(value)
    end

    def expr(*parts)
      Math::Formula.new(parts)
    end
  end
end
