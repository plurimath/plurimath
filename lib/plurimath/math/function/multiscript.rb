# frozen_string_literal: true

require_relative "ternary_function"
module Plurimath
  module Math
    module Function
      class Multiscript < TernaryFunction
        def to_omml_without_math_tag
          pre_element = Utility.ox_element("sPre", namespace: "m")
          pr_element  = Utility.ox_element("sPrePr", namespace: "m")
          sub_element = Utility.ox_element("sub", namespace: "m")
          sub_element << parameter_two.to_omml_without_math_tag if parameter_two
          sup_element = Utility.ox_element("sup", namespace: "m")
          sup_element << parameter_three.to_omml_without_math_tag if parameter_three
          e_element   = Utility.ox_element("e", namespace: "m")
          e_element  << parameter_one.to_omml_without_math_tag if parameter_one
          Utility.update_nodes(
            pre_element,
            [
              pr_element << Utility.pr_element("ctrl", true, namespace: "m"),
              sub_element,
              sup_element,
              e_element,
            ],
          )
        end
      end
    end
  end
end
