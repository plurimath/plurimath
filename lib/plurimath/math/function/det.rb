# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Det < UnaryFunction
        attr_accessor :scalar

        def initialize(scalar = nil)
          @scalar = scalar
        end
      end
    end
  end
end
