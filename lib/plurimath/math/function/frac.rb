# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Frac < BinaryFunction
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

        def to_omml_without_math_tag
          f_element   = Utility.ox_element("f", namespace: "m")
          fpr_element = Utility.ox_element("fPr", namespace: "m")
          Utility.update_nodes(
            f_element,
            [
              fpr_element << Utility.pr_element("ctrl", true, namespace: "m"),
              num_element,
              den_element,
            ],
          )
          [f_element]
        end

        def num_element
          num_element = Utility.ox_element("num", namespace: "m")
          return empty_tag(num_element) unless parameter_one

          Utility.update_nodes(num_element, insert_t_tag(parameter_one))
        end

        def den_element
          den_element = Utility.ox_element("den", namespace: "m")
          return empty_tag(den_element) unless parameter_two

          Utility.update_nodes(den_element, insert_t_tag(parameter_two))
        end
      end
    end
  end
end
