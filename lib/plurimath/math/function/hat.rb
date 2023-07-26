# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Hat < UnaryFunction
        def to_mathml_without_math_tag
          mover_tag    = Utility.ox_element("mover")
          first_value  = parameter_one&.to_mathml_without_math_tag
          second_value = (Utility.ox_element("mo") << "^")
          Utility.update_nodes(
            mover_tag,
            [
              first_value,
              second_value,
            ],
          )
        end

        def validate_function_formula
          false
        end

        def to_omml_without_math_tag
          acc_tag    = Utility.ox_element("acc", namespace: "m")
          acc_pr_tag = Utility.ox_element("accPr", namespace: "m")
          acc_pr_tag << (Utility.ox_element("chr", namespace: "m", attributes: { "m:val": "̂" }))
          me = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(me, omml_value)
          Utility.update_nodes(
            acc_tag,
            [acc_pr_tag, me],
          )
          [acc_tag]
        end
      end
    end
  end
end
