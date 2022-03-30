# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ln < UnaryFunction
        attr_accessor :exponent

        def initialize(exponent = nil)
          @exponent = exponent
        end
      end
    end
  end
end
