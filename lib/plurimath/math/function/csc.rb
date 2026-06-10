# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Csc < UnaryFunction
        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          evaluator.divide(1.0, ::Math.sin(evaluator.evaluate_node(parameter_one)))
        end
      end
    end
  end
end
