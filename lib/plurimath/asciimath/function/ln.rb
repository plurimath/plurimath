# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Ln
        attr_accessor :exponent

        def initialize(exponent)
          @exponent = exponent
        end
      end
    end
  end
end
