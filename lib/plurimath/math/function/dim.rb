# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Dim < UnaryFunction
        attr_accessor :dimensions

        def initialize(dimensions = nil)
          @dimensions = dimensions
        end
      end
    end
  end
end
