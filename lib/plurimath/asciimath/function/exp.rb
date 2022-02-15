# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Exp
        attr_accessor :exponent

        def initialize(exponent)
          @exponent = exponent
        end
      end
    end
  end
end
