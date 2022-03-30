# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Frac < BinaryFunction
        attr_accessor :dividend, :divisor

        def initialize(dividend = nil, divisor = nil)
          @dividend = dividend
          @divisor = divisor
        end
      end
    end
  end
end
