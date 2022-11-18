# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Underset < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element("munder"),
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
          second_value = parameter_two.to_omml_without_math_tag
          limlow   = Utility.ox_element("limLow", namespace: "m")
          limlowpr = Utility.ox_element("limLowPr", namespace: "m")
          limlowpr << Utility.pr_element("ctrl", true, namespace: "m")
          me = Utility.ox_element("e", namespace: "m") << first_value
          lim = Utility.ox_element("lim", namespace: "m") << second_value
          Utility.update_nodes(
            limlow,
            [
              limlowpr,
              me,
              lim,
            ],
          )
        end
      end
    end
  end
end
