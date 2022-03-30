# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Color < BinaryFunction
        attr_accessor :color, :value

        def initialize(color = nil, value = nil)
          @color = color
          @value = value
        end
      end
    end
  end
end
