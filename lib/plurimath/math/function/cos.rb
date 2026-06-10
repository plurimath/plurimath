# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Cos < UnaryFunction
        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          ::Math.cos(evaluator.evaluate_node(parameter_one))
        end
      end
    end
  end
end
