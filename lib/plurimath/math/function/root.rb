# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Root < BinaryFunction
        attr_accessor :index, :number

        def initialize(index = nil, number = nil)
          @index = index
          @number = number
        end
      end
    end
  end
end
