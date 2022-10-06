# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Frac < BinaryFunction
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
          f_element   = Utility.omml_element("m:f")
          fpr_element = Utility.omml_element("m:fPr")
          num_element = Utility.omml_element("m:num")
          den_element = Utility.omml_element("m:den")
          Utility.update_nodes(
            f_element,
            [
              fpr_element << Utility.pr_element("m:ctrl", true),
              num_element << parameter_one.to_omml_without_math_tag,
              den_element << parameter_two.to_omml_without_math_tag,
            ],
          )
        end
      end
    end
  end
end
