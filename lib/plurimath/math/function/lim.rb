# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Lim < BinaryFunction
        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "lim#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          munderover  = Utility.ox_element("munderover")
          first_value = (Utility.ox_element("mo") << "lim")
          if parameter_one || parameter_two
            value_array = []
            value_array << parameter_one&.to_mathml_without_math_tag
            value_array << parameter_two&.to_mathml_without_math_tag
            Utility.update_nodes(
              munderover,
              value_array.insert(0, first_value),
            )
          else
            first_value
          end
        end

        def to_omml_without_math_tag
          limupp = Utility.ox_element("limUpp", namespace: "m")
          limpr = Utility.ox_element("limUppPr", namespace: "m")
          limpr << Utility.pr_element("ctrl", namespace: "m")
          e_tag = Utility.ox_element("e", namespace: "m")
          e_tag << parameter_one&.to_omml_without_math_tag
          lim = Utility.ox_element("lim", namespace: "m")
          lim << parameter_two&.to_omml_without_math_tag if parameter_two
          Utility.update_nodes(
            limupp,
            [
              e_tag,
              lim,
            ],
          )
        end
      end
    end
  end
end
