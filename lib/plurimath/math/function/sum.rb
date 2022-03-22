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
        alias :value :base
      end
    end
  end
end
