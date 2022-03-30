# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Gcd < UnaryFunction
        attr_accessor :value

        def initialize(value = nil)
          @value = value
        end
      end
    end
  end
end
