# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Ln
        attr_accessor :exponent

        def initialize(exponent)
          @exponent = exponent
        end

        def to_asciimath
          "ln#{exponent&.to_asciimath}"
        end

        def ==(object)
          object == exponent
        end
      end
    end
  end
end
