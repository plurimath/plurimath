# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Mod
        attr_accessor :dividend, :divisor

        def initialize(dividend, divisor)
          @dividend = dividend
          @divisor = divisor
        end
      end
    end
  end
end
