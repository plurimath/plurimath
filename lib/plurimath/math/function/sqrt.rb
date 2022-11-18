# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Sqrt < UnaryFunction
        def to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element("msqrt"),
            parameter_one&.to_mathml_without_math_tag,
          )
        end

        def to_omml_without_math_tag
          rad_element = Utility.ox_element("rad", namespace: "m")
          pr_element = Utility.ox_element("radPr", namespace: "m")
          pr_element << Utility.ox_element(
            "degHide",
            namespace: "m",
            attributes: { "m:val": "1" },
          )
          e_element = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(
            rad_element,
            [
              pr_element << Utility.pr_element("ctrl", true, namespace: "m"),
              Utility.ox_element("deg", namespace: "m"),
              e_element << parameter_one.to_omml_without_math_tag,
            ],
          )
          rad_element
        end
      end
    end
  end
end
