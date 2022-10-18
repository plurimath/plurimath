# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Log < BinaryFunction
        def to_asciimath
          first_value = "_#{parameter_one.to_asciimath}" if parameter_one
          second_value = "^#{parameter_two.to_asciimath}" if parameter_two
          "log#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\log#{first_value}#{second_value}"
        end

        def to_html
          first_value = "<sub>#{parameter_one.to_html}</sub>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html}</sup>" if parameter_two
          "<i>log</i>#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag
          func   = Utility.omml_element("func", namespace: "m")
          funcpr = Utility.omml_element("funcPr", namespace: "m")
          funcpr << Utility.pr_element("ctrl", true, namespace: "m")
          fname  = Utility.omml_element("fName", namespace: "m")
          mr     = Utility.omml_element("r", namespace: "m")
          rpr    = Utility.rpr_element
          mt     = Utility.omml_element("t", namespace: "m") << class_name
          fname << Utility.update_nodes(mr, [rpr, mt])
          log_values = [first_value, second_value].flatten.compact
          Utility.update_nodes(
            func,
            [
              funcpr,
              fname,
            ] + log_values,
          )
        end

        def first_value
          return nil if parameter_one.nil?

          first_value = parameter_one.to_omml_without_math_tag
          Utility.omml_element("e", namespace: "m") << first_value
        end

        def second_value
          return nil if parameter_two.nil?

          second_value = parameter_two.to_omml_without_math_tag
          Utility.omml_element("e", namespace: "m") << second_value
        end
      end
    end
  end
end
