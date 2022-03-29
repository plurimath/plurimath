# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Color
        attr_accessor :color, :value

        def initialize(color = nil, value = nil)
          @color = color
          @value = value
        end

        def to_asciimath
          "color#{color&.to_asciimath}#{value&.to_asciimath}"
        end

        def ==(object)
          object.color == color && object.value == value
        end
      end
    end
  end
end
