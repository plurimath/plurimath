# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Norm < UnaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          "<mo>&#x2225;</mo>#{first_value}<mo>&#x2225;</mo>"
        end
      end
    end
  end
end
