# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Root < BinaryFunction
        FUNCTION = {
          name: "root",
          first_value: "radicand",
          second_value: "index",
        }.freeze

        def to_mathml_without_math_tag(intent)
          first_value = parameter_one&.to_mathml_without_math_tag(intent)
          second_value = parameter_two&.to_mathml_without_math_tag(intent)
          Utility.update_nodes(
            Utility.ox_element("mroot"),
            [second_value, first_value],
          )
        end

        def to_latex
          first_value = parameter_one&.to_latex
          second_value = parameter_two&.to_latex
          "\\sqrt[#{first_value}]{#{second_value}}"
        end

        def to_omml_without_math_tag(display_style)
          attribute = { "m:val": "off" }
          rad_element = Utility.ox_element("rad", namespace: "m")
          pr_element  = Utility.ox_element("radPr", namespace: "m")
          pr_element << Utility.ox_element("degHide", namespace: "m", attributes: attribute)
          Utility.update_nodes(
            rad_element,
            [
              pr_element,
              omml_parameter(parameter_two, display_style, tag_name: "deg"),
              omml_parameter(parameter_one, display_style, tag_name: "e"),
            ],
          )
          [rad_element]
        end

        def to_unicodemath
          first_value = parameter_one.to_unicodemath if parameter_one
          second_value = parameter_two.to_unicodemath if parameter_two
          "√(#{first_value}&#{second_value})"
        end
      end
    end
  end
end
