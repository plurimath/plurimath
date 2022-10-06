# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Underover < TernaryFunction
        def omml_nary_tag
          first_val  = parameter_one.to_omml_without_math_tag
          pr_element = Utility.omml_element("m:naryPr")
          unless first_val == "∫"
            pr_element << Utility.omml_element("m:chr", { "m:val": first_val })
          end
          pr_element << Utility.omml_element("m:limLoc", { "m:val": "undOvr" })
          pr_element << hidden_sub_tag if parameter_two.nil?
          pr_element << hidden_sup_tag if parameter_three.nil?
          pr_element << Utility.pr_element("m:ctrl", true)
          sub_element  = Utility.omml_element("m:sub")
          sub_element << parameter_two&.to_omml_without_math_tag if parameter_two
          sup_element = Utility.omml_element("m:sup")
          sup_element << parameter_three&.to_omml_without_math_tag if parameter_three
          [pr_element, sub_element, sup_element]
        end

        def hidden_sub_tag
          Utility.omml_element("m:subHide", { "m:val": 1 })
        end

        def hidden_sup_tag
          Utility.omml_element("m:supHide", { "m:val": 1 })
        end
      end
    end
  end
end
