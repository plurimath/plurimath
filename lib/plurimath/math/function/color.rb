# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Color < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one.value if parameter_one
          second_value = parameter_two.to_mathml_without_math_tag if parameter_two
          "<mstyle mathcolor='#{first_value}'>#{second_value}</mstyle>"
        end
      end
    end
  end
end
