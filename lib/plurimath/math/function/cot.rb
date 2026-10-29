# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Cot < UnaryFunction
        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          evaluator.divide(1.0, ::Math.tan(evaluator.evaluate_node(parameter_one)))
        end
      end
    end
  end
end
