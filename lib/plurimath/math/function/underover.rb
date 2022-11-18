# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Underover < TernaryFunction
        def omml_nary_tag
          pr = Utility.ox_element("naryPr", namespace: "m")
          sub = Utility.ox_element("sub", namespace: "m")
          sub << parameter_two&.to_omml_without_math_tag if parameter_two
          sup = Utility.ox_element("sup", namespace: "m")
          sup << parameter_three&.to_omml_without_math_tag if parameter_three
          [pr_element_value(pr), sub, sup]
        end

        def hidden_sub_tag(pr_element)
          return true unless parameter_two.nil?

          pr_element << Utility.ox_element(
            "subHide",
            namespace: "m",
            attributes: { "m:val": 1 },
          )
        end

        def hidden_sup_tag(pr_element)
          return true unless parameter_three.nil?

          pr_element << Utility.ox_element(
            "supHide",
            namespace: "m",
            attributes: { "m:val": 1 },
          )
        end

        def pr_element_value(pr_element)
          first_value(pr_element)
          pr_element << Utility.ox_element(
            "limLoc",
            namespace: "m",
            attributes: { "m:val": "undOvr" },
          )
          hidden_sub_tag(pr_element)
          hidden_sup_tag(pr_element)
          pr_element << Utility.pr_element("ctrl", true, namespace: "m")
        end

        def first_value(pr_element)
          first_value = parameter_one.to_omml_without_math_tag
          unless first_value == "∫"
            pr_element << Utility.ox_element(
              "chr",
              namespace: "m",
              attributes: { "m:val": first_value },
            )
          end
        end
      end
    end
  end
end
