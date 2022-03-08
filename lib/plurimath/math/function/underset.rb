# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Underset
        attr_accessor :value, :symbol

        def initialize(value, symbol)
          @value = value
          @symbol = symbol
        end

        def to_asciimath
          "underset#{value&.to_asciimath}#{symbol&.to_asciimath}"
        end
      end
    end
  end
end
