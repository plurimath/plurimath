# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sin < UnaryFunction
        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          ::Math.sin(evaluator.evaluate_node(parameter_one))
        end
      end
    end
  end
end
