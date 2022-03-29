# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Gcd
        attr_accessor :values

        def initialize(values)
          @values = values
        end

        def to_asciimath
          "gcd#{values&.to_asciimath}"
        end

        def ==(object)
          object == values
        end
      end
    end
  end
end
