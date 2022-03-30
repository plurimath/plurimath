# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Sqrt < UnaryFunction
        attr_accessor :number

        def initialize(number = nil)
          @number = number
        end
      end
    end
  end
end
