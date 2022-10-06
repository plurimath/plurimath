# frozen_string_literal: true

require_relative "ternary_function"
module Plurimath
  module Math
    module Function
      class Multiscript < TernaryFunction
        def to_omml_without_math_tag
          pre_element = Utility.omml_element("m:sPre")
          pr_element  = Utility.omml_element("m:sPrePr")
          sub_element = Utility.omml_element("m:sub")
          sup_element = Utility.omml_element("m:sup")
          e_element   = Utility.omml_element("m:e")
          Utility.update_nodes(
            pre_element,
            [
              pr_element  << Utility.pr_element("m:ctrl", true),
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
