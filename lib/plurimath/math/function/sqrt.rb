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
      end
    end
  end
end
