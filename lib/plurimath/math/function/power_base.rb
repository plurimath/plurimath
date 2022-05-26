# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class PowerBase < TernaryFunction
        def to_mathml_without_math_tag
          first_value  = parameter_one.to_mathml_without_math_tag if parameter_one
          second_value = parameter_two.to_mathml_without_math_tag if parameter_two
          third_value  = parameter_three.to_mathml_without_math_tag if parameter_three
          "<msubsup>#{first_value}#{second_value}#{third_value}</msubsup>"
        end
      end
    end
  end
end
