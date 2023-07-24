# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Power < BinaryFunction
        def to_asciimath
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "#{parameter_one.to_asciimath}#{second_value}"
        end

        def to_mathml_without_math_tag
          tag_name = (["ubrace", "obrace"].include?(parameter_one&.class_name) ? "over" : "sup")
          sup_tag = Utility.ox_element("m#{tag_name}")
          mathml_value = [parameter_one.to_mathml_without_math_tag]
          mathml_value << parameter_two&.to_mathml_without_math_tag
          Utility.update_nodes(sup_tag, mathml_value)
        end

        def to_latex
          first_value  = parameter_one.to_latex
          second_value = parameter_two.to_latex if parameter_two
          "#{first_value}^{#{second_value}}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html}</sup>" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag
          ssup_element  = Utility.ox_element("sSup", namespace: "m")
          suppr_element = Utility.ox_element("sSupPr", namespace: "m")
          suppr_element << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            ssup_element,
            [
              suppr_element,
              omml_parameter(parameter_one, tag_name: "e"),
              omml_parameter(parameter_two, tag_name: "sup"),
            ],
          )
          [ssup_element]
        end
      end
    end
  end
end
