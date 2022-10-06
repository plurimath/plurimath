# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Underset < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          "<munder>#{second_value}#{first_value}</munder>"
        end

        def to_omml_without_math_tag
          first_value  = if parameter_one.is_a?(Math::Symbol)
                           mt = Utility.omml_element("m:t")
                           mt << parameter_one.to_omml_without_math_tag
                         else
                           parameter_one.to_omml_without_math_tag
                         end
          second_value = parameter_two.to_omml_without_math_tag
          limlow   = Utility.omml_element("m:limLow")
          limlowpr = Utility.omml_element("m:limLowPr")
          limlowpr << Utility.pr_element("m:ctrl", true)
          me = Utility.omml_element("m:e") << first_value
          lim = Utility.omml_element("m:lim") << second_value
          Utility.update_nodes(
            limlow,
            [
              limlowpr,
              me,
              lim,
            ],
          )
        end
      end
    end
  end
end
