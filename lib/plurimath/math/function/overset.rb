# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Overset < BinaryFunction
        attr_accessor :value, :symbol

        def initialize(value = nil, symbol = nil)
          @value = value
          @symbol = symbol
        end
      end
    end
  end
end
