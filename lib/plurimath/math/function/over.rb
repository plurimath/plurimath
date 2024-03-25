# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Over < BinaryFunction
        FUNCTION = {
          name: "over",
          first_value: "numerator",
          second_value: "denominator",
        }.freeze

        def to_asciimath
          first_value = wrapped(parameter_one)
          second_value = wrapped(parameter_two)
          "frac#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          tag_name = hide_function_name ? "mrow" : "mfrac"
          mathml_value  = [
            parameter_one&.to_mathml_without_math_tag,
            parameter_two&.to_mathml_without_math_tag,
          ]
          Utility.update_nodes(ox_element(tag_name), mathml_value)
        end

        def to_latex
          first_value = parameter_one&.to_latex
          two_value = parameter_two&.to_latex
          "{#{first_value} \\over #{two_value}}"
        end

        def to_omml_without_math_tag(display_style)
          f_element   = Utility.ox_element("f", namespace: "m")
          fpr_element = Utility.ox_element("fPr", namespace: "m")
          Utility.update_nodes(
            f_element,
            [
              fpr_element << Utility.pr_element("ctrl", true, namespace: "m"),
              omml_parameter(parameter_one, display_style, tag_name: "num"),
              omml_parameter(parameter_two, display_style, tag_name: "den"),
            ],
          )
          [f_element]
        end

        def to_unicodemath
          first_value = unicodemath_parens(parameter_one) if parameter_one
          second_value = unicodemath_parens(parameter_two) if parameter_two
          "#{first_value}/#{second_value}"
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
            over = self.class.new(nil, Utility.filter_values(obj.value))
            over.hide_function_name = true
            obj.update(over)
          end
        end
      end
    end
  end
end
