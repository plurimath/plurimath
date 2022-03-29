# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Stackrel
        attr_accessor :base, :exponent

        def initialize(base, exponent)
          @base = base
          @exponent = exponent
        end

        def ==(object)
          object.base == base && object.exponent == exponent
        end
      end
    end
  end
end
