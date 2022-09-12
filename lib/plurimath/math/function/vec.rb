# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Vec < UnaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          "<mover>#{first_value}<mo>&#x20D1;</mo></mover>"
        end
      end
    end
  end
end
