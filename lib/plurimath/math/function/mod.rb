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

        def to_asciimath
          "#{dividend&.to_asciimath}mod#{divisor&.to_asciimath}"
        end
      end
    end
  end
end
