# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Frac < BinaryFunction
        def to_asciimath
          first_value = parameter_one.to_asciimath if parameter_one
          second_value = parameter_two.to_asciimath if parameter_two
          "frac#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          two_value = parameter_two&.to_mathml_without_math_tag
          "<mfrac>#{first_value}#{two_value}</mfrac>"
        end

        def to_latex
          first_value = parameter_one&.to_latex
          two_value = parameter_two&.to_latex
          "\\frac{#{first_value}}{#{two_value}}"
        end

        def to_omml_without_math_tag
          f_element   = Utility.omml_element("f", namespace: "m")
          fpr_element = Utility.omml_element("fPr", namespace: "m")
          num_element = Utility.omml_element("num", namespace: "m")
          den_element = Utility.omml_element("den", namespace: "m")
          Utility.update_nodes(
            f_element,
            [
              fpr_element << Utility.pr_element("ctrl", true, namespace: "m"),
              num_element << parameter_one.to_omml_without_math_tag,
              den_element << parameter_two.to_omml_without_math_tag,
            ],
          )
        end
      end
    end
  end
end
