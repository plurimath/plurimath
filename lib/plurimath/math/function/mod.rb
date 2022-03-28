# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Mod
        attr_accessor :dividend, :divisor

        def initialize(dividend, divisor)
          @dividend = dividend
          @divisor = divisor
        end

        def ==(object)
          object.dividend == dividend && object.divisor == divisor
        end
      end
    end
  end
end
