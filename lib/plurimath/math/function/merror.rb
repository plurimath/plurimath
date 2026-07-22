# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Merror < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        # MathML-only element: it has no AsciiMath/LaTeX form, so those render
        # empty — accepted for the catalog (no page vanishes).
        DESCRIPTION = "Displays its argument as a MathML error message."
        REFERENCE = "https://developer.mozilla.org/en-US/docs/Web/MathML/Reference/Element/merror"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def to_asciimath(**); end

        def to_latex(**); end

        def to_mathml_without_math_tag(intent, options:)
          merror = XmlHelper.ox_element("merror")
          XmlHelper.update_nodes(merror, mathml_value(intent, options: options))
        end

        def to_omml_without_math_tag(_, **); end

        def to_unicodemath(**); end
      end
    end
  end
end
