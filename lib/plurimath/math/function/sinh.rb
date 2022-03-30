# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Sinh < UnaryFunction
        attr_accessor :angle

        def initialize(angle = nil)
          @angle = angle
        end
      end
    end
  end
end
