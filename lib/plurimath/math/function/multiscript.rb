# frozen_string_literal: true

require_relative "ternary_function"
module Plurimath
  module Math
    module Function
      class Multiscript < TernaryFunction
        def to_omml_without_math_tag
          pre_element = Utility.ox_element("sPre", namespace: "m")
          pr_element  = Utility.ox_element("sPrePr", namespace: "m")
          Utility.update_nodes(
            pre_element,
            [
              pr_element << Utility.pr_element("ctrl", true, namespace: "m"),
              omml_parameter(parameter_two, tag_name: "sub"),
              omml_parameter(parameter_three, tag_name: "sup"),
              omml_parameter(parameter_one, tag_name: "e"),
            ],
          )
          [pre_element]
        end
      end
    end
  end
end
