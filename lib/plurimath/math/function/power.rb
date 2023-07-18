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
              e_parameter,
              sup_parameter,
            ],
          )
          [ssup_element]
        end

        protected

        def e_parameter
          e_tag = Utility.ox_element("e", namespace: "m")
          return empty_tag(e_tag) unless parameter_one

          Utility.update_nodes(e_tag, insert_t_tag(parameter_one))
        end

        def sup_parameter
          sup_tag = Utility.ox_element("sup", namespace: "m")
          return empty_tag(sup_tag) unless parameter_two

         Utility.update_nodes(sup_tag, insert_t_tag(parameter_two))
        end

        def empty_tag(wrapper_tag)
          r_tag = Utility.ox_element("r", namespace: "m")
          r_tag << (Utility.ox_element("t", namespace: "m") << "&#8203;")
          wrapper_tag << r_tag
        end

        def insert_t_tag(parameter)
          parameter_value = parameter.to_omml_without_math_tag
          r_tag = Utility.ox_element("r", namespace: "m")
          if parameter.is_a?(Symbol)
            r_tag << (Utility.ox_element("t", namespace: "m") << parameter_value)
            [r_tag]
          elsif parameter.is_a?(Number)
            Array(Utility.update_nodes(r_tag, parameter_value))
          else
            parameter_value
          end
        end
      end
    end
  end
end
