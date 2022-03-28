# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Exp
        attr_accessor :exponent

        def initialize(exponent)
          @exponent = exponent
        end

        def ==(object)
          object == exponent
        end
      end
    end
  end
end
