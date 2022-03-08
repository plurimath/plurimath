# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Ddot
        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def to_asciimath
          "ddot#{value&.to_asciimath}"
        end
      end
    end
  end
end
