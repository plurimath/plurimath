# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Overset < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          "<mover>#{second_value}#{first_value}</mover>"
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}" if parameter_one
          second_value = "#{parameter_two.to_latex}}" if parameter_two
          "#{first_value}\\over#{second_value}"
        end

        def to_omml_without_math_tag
          first_value  = if parameter_one.is_a?(Math::Symbol)
                           mt = Utility.omml_element("t", namespace: "m")
                           mt << parameter_one.to_omml_without_math_tag
                         else
                           parameter_one.to_omml_without_math_tag
                         end
          second_value = if parameter_two.is_a?(String)
                           parameter_two
                         else
                           parameter_two.to_omml_without_math_tag
                         end
          limupp   = Utility.omml_element("limUpp", namespace: "m")
          limupppr = Utility.omml_element("limUppPr", namespace: "m")
          limupppr << Utility.pr_element("ctrl", true, namespace: "m")
          me = Utility.omml_element("e", namespace: "m") << first_value
          lim = Utility.omml_element("lim", namespace: "m") << second_value
          Utility.update_nodes(
            limupp,
            [
              limupppr,
              me,
              lim,
            ],
          )
        end
      end
    end
  end
end
