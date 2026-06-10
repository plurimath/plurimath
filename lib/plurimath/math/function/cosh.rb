# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Cosh < UnaryFunction
        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          ::Math.cosh(evaluator.evaluate_node(parameter_one))
        end
      end
    end
  end
end
