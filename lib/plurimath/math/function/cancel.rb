# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Cancel < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "Strikes its argument through with a diagonal line."
        REFERENCE = "https://developer.mozilla.org/en-US/docs/Web/MathML/Reference/Element/menclose"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def to_mathml_without_math_tag(intent, options:)
          cancel_tag = XmlHelper.ox_element(
            "menclose",
            attributes: { notation: "updiagonalstrike" },
          )
          first_value = parameter_one&.to_mathml_without_math_tag(intent,
                                                                  options: options)
          XmlHelper.update_nodes(cancel_tag, [first_value])
        end

        def to_omml_without_math_tag(display_style, options:)
          omml_value(display_style, options: options)
        end

        def to_unicodemath(options:)
          if parameter_one
            first_value = unicodemath_parens(parameter_one,
                                             options: options)
          end
          "╱#{first_value}"
        end
      end
    end
  end
end
