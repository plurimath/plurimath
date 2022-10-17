# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Sqrt < UnaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          "<msqrt>#{first_value}</msqrt>"
        end

        def to_omml_without_math_tag
          rad_element = Utility.omml_element("m:rad")
          pr_element  = Utility.omml_element("m:radPr")
          pr_element << Utility.omml_element("m:degHide", { "m:val": "1" })
          e_element   = Utility.omml_element("m:e")
          Utility.update_nodes(
            rad_element,
            [
              pr_element << Utility.pr_element("m:ctrl", true),
              Utility.omml_element("m:deg"),
              e_element << parameter_one.to_omml_without_math_tag,
            ],
          )
          rad_element
        end
      end
    end
  end
end
