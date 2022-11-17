# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Root < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.omml_element("mroot"),
            [
              first_value,
              second_value,
            ],
          )
        end

        def to_latex
          first_value = parameter_one&.to_latex
          second_value = parameter_two&.to_latex
          "\\sqrt[#{first_value}]{#{second_value}}"
        end

        def to_omml_without_math_tag
          rad_element = Utility.omml_element("rad", namespace: "m")
          pr_element  = Utility.omml_element("radPr", namespace: "m")
          deg_element = Utility.omml_element("deg", namespace: "m")
          e_element   = Utility.omml_element("e", namespace: "m")
          Utility.update_nodes(
            rad_element,
            [
              pr_element  << Utility.pr_element("ctrl", true, namespace: "m"),
              deg_element << parameter_two.to_omml_without_math_tag,
              e_element   << parameter_one.to_omml_without_math_tag,
            ],
          )
          rad_element
        end
      end
    end
  end
end
