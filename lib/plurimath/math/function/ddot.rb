# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ddot < UnaryFunction
        def to_mathml_without_math_tag
          second_value = Utility.ox_element("mo") << ".."
          Utility.update_nodes(
            Utility.ox_element("mover", attributes: { accent: "true" }),
            mathml_value << second_value,
          )
        end

        def to_omml_without_math_tag
          acc_tag    = Utility.ox_element("acc", namespace: "m")
          acc_pr_tag = Utility.ox_element("accPr", namespace: "m")
          acc_pr_tag << (Utility.ox_element("chr", namespace: "m", attributes: { "m:val": ".." }))
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
