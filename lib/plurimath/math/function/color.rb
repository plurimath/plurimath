# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Color
        attr_accessor :color, :value

        def initialize(color, value)
          @color = color
          @value = value
        end
      end
    end
  end
end
