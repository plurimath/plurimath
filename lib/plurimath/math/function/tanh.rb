# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Tanh < UnaryFunction
        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          ::Math.tanh(evaluator.evaluate_node(parameter_one))
        end
      end
    end
  end
end
