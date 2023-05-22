# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Floor < UnaryFunction
        def to_latex
          "{\\lfloor #{parameter_one.to_latex} \\rfloor}"
        end

        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            [
              Utility.ox_element("mo") << "&#x230a;",
              first_value,
              Utility.ox_element("mo") << "&#x230b;",
            ],
          )
        end

        def to_omml_without_math_tag(display_style)
          [
            r_element("⌊"),
            omml_value(display_style),
            r_element("⌋"),
          ]
        end
      end
    end
  end
end
