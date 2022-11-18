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
          sup_element = Utility.ox_element("sup", namespace: "m")
          e_element   = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(
            pre_element,
            [
              pr_element  << Utility.pr_element("ctrl", true, namespace: "m"),
              sub_element << parameter_two.to_omml_without_math_tag,
              sup_element << parameter_three.to_omml_without_math_tag,
              e_element   << parameter_one.to_omml_without_math_tag,
            ],
          )
        end
      end
    end
  end
end
