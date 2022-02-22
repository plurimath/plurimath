# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Log
        attr_accessor :base, :exponent

        def initialize(base, exponent)
          @base = base
          @exponent = exponent
        end
      end
    end
  end
end
