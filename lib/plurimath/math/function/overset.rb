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
          limupp   = Utility.ox_element("limUpp", namespace: "m")
          limupppr = Utility.ox_element("limUppPr", namespace: "m")
          limupppr << Utility.pr_element("ctrl", true, namespace: "m")
          me = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(me, insert_t_tag(parameter_one))
          lim = Utility.ox_element("lim", namespace: "m")
          Utility.update_nodes(lim, insert_t_tag(parameter_two))
          Utility.update_nodes(
            limupp,
            [
              limupppr,
              me,
              lim,
            ],
          )
          [limupp]
        end
      end
    end
  end
end
