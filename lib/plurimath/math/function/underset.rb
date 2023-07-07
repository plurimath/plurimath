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
          me = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(me, insert_t_tag(parameter_one))
          lim = Utility.ox_element("lim", namespace: "m")
          Utility.update_nodes(lim, insert_t_tag(parameter_two))
          Utility.update_nodes(
            limlow,
            [
              limlowpr,
              me,
              lim,
            ],
          )
          [limlow]
        end
      end
    end
  end
end
