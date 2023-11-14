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
          tag_name = hide_function_name ? "mfrac" : "mrow"
          mathml_value = [
            parameter_one&.to_mathml_without_math_tag,
            parameter_two&.to_mathml_without_math_tag,
          ]
          Utility.update_nodes(ox_element("mfrac"), mathml_value)
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

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two))
            self.parameter_two = nil
            self.hide_function_name = true
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            frac = self.class.new(nil, Utility.filter_values(obj.value))
            frac.hide_function_name = true
            obj.update(frac)
          end
        end
      end
    end
  end
end
