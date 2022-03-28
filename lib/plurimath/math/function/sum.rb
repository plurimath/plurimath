# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sum
        attr_accessor :base, :exponent

        def initialize(base = nil, exponent = nil)
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
