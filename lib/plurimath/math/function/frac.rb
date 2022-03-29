# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Frac
        attr_accessor :dividend, :divisor

        def initialize(dividend = nil, divisor = nil)
          @dividend = dividend
          @divisor = divisor
        end

        def to_asciimath
          "frac#{dividend&.to_asciimath}#{divisor&.to_asciimath}"
        end

        def ==(object)
          object.dividend == dividend && object.divisor == divisor
        end
      end
    end
  end
end
