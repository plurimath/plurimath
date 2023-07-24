# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Cosh < UnaryFunction
        def validate_function_formula
          false
        end
      end
    end
  end
end
