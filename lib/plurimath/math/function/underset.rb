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
          limlow   = Utility.ox_element("limLow", namespace: "m")
          limlowpr = Utility.ox_element("limLowPr", namespace: "m")
          limlowpr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            limlow,
            [
              limlowpr,
              omml_parameter(parameter_one, tag_name: "e"),
              omml_parameter(parameter_two, tag_name: "lim"),
            ],
          )
          [limlow]
        end
      end
    end
  end
end
