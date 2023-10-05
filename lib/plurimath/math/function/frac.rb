# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Frac < BinaryFunction
        FUNCTION = {
          name: "fraction",
          first_value: "numerator",
          second_value: "denominator",
        }.freeze

        def to_asciimath
          first_value = "(#{parameter_one&.to_asciimath})" if parameter_one
          second_value = "(#{parameter_two&.to_asciimath})" if parameter_two
          "frac#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          frac_tag     = Utility.ox_element("mfrac")
          first_value  = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          Utility.update_nodes(
            frac_tag,
            [
              first_value,
              second_value,
            ].flatten,
          )
        end

        def to_latex
          first_value = parameter_one&.to_latex
          two_value = parameter_two&.to_latex
          "\\frac{#{first_value}}{#{two_value}}"
        end

        def to_omml_without_math_tag(display_style)
          f_element   = Utility.ox_element("f", namespace: "m")
          fpr_element = Utility.ox_element("fPr", namespace: "m")
          fpr_element << Utility.pr_element("ctrl", true, namespace: "m")
          Array(
            Utility.update_nodes(
              f_element,
              [
                fpr_element,
                omml_parameter(parameter_one, display_style, tag_name: "num"),
                omml_parameter(parameter_two, display_style, tag_name: "den"),
              ],
            ),
          )
        end
      end
    end
  end
end
