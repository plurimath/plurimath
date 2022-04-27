# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Fenced < TernaryFunction
        def to_asciimath
          first_value  = parameter_one ? parameter_one.to_asciimath : "("
          second_value = parameter_two.map(&:to_asciimath).join(",") if parameter_two
          third_value  = parameter_three ? parameter_three.to_asciimath : ")"
          "#{first_value}#{second_value}#{third_value}"
        end
      end
    end
  end
end
