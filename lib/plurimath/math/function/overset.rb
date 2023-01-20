# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Overset < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          over_tag = Utility.ox_element("mover")
          Utility.update_nodes(
            over_tag,
            [
              second_value,
              first_value,
            ],
          )
        end

        def to_omml_without_math_tag
          first_value  = if parameter_one.is_a?(Math::Symbol)
                           mt = Utility.ox_element("t", namespace: "m")
                           mt << parameter_one.to_omml_without_math_tag
                         else
                           parameter_one.to_omml_without_math_tag
                         end
          second_value = if parameter_two.is_a?(Math::Symbol)
                           mt = Utility.ox_element("t", namespace: "m")
                           mt << parameter_two.to_omml_without_math_tag
                         else
                           parameter_two.to_omml_without_math_tag
                         end
          limupp   = Utility.ox_element("limUpp", namespace: "m")
          limupppr = Utility.ox_element("limUppPr", namespace: "m")
          limupppr << Utility.pr_element("ctrl", true, namespace: "m")
          me = (Utility.ox_element("e", namespace: "m") << first_value)
          lim = (Utility.ox_element("lim", namespace: "m") << second_value)
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
