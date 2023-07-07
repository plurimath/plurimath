# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Base < BinaryFunction
        def to_asciimath
          first_value = parameter_one.to_asciimath if parameter_one
          second_value = "_#{wrapped(parameter_two)}" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          tag_name = (Utility::MUNDER_CLASSES.include?(parameter_one&.class_name) ? "under" : "sub")
          sub_tag = Utility.ox_element("m#{tag_name}")
          mathml_value = []
          mathml_value << parameter_one&.to_mathml_without_math_tag
          mathml_value << parameter_two&.to_mathml_without_math_tag if parameter_two
          Utility.update_nodes(sub_tag, mathml_value)
        end

        def to_latex
          first_value  = parameter_one.to_latex if parameter_one
          first_value  = "{#{first_value}}" if parameter_one.is_a?(Formula)
          second_value = parameter_two.to_latex if parameter_two
          "#{first_value}_{#{second_value}}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<sub>#{parameter_two.to_html}</sub>" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag
          ssub_element  = Utility.ox_element("sSub", namespace: "m")
          subpr_element = Utility.ox_element("sSubPr", namespace: "m")
          e_element     = Utility.ox_element("e", namespace: "m")
          subpr_element << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            ssub_element,
            [
              subpr_element,
              e_parameter,
              sub_parameter,
            ],
          )
          [ssub_element]
        end

        protected

        def e_parameter
          e_tag = Utility.ox_element("e", namespace: "m")
          return empty_tag(e_tag) unless parameter_one

          Utility.update_nodes(e_tag, insert_t_tag(parameter_one))
          e_tag
        end

        def sub_parameter
          sub_tag = Utility.ox_element("sub", namespace: "m")
          return empty_tag(sub_tag) unless parameter_two

          Utility.update_nodes(sub_tag, insert_t_tag(parameter_two))
          sub_tag
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
          elsif parameter.is_a?(Number) || parameter.is_a?(Function::Text)
            Utility.update_nodes(r_tag, parameter_value)
            [r_tag]
          else
            Array(parameter_value)
          end
        end
      end
    end
  end
end
