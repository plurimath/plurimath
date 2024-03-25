# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Cancel < UnaryFunction
        def to_mathml_without_math_tag
          cancel_tag = Utility.ox_element(
            "menclose",
            attributes: { notation: "updiagonalstrike" },
          )
          first_value = parameter_one&.to_mathml_without_math_tag
          Utility.update_nodes(cancel_tag, [first_value])
        end

        def to_omml_without_math_tag(display_style)
          omml_value(display_style)
        end

        def to_unicodemath
          first_value = unicodemath_parens(parameter_one) if parameter_one
          "╱#{first_value}"
        end
      end
    end
  end
end
