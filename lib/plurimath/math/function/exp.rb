# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Exp < UnaryFunction
        def validate_function_formula
          false
        end
      end
    end
  end
end
