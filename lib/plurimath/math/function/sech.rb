# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sech < UnaryFunction
        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          evaluator.divide(1.0, ::Math.cosh(evaluator.evaluate_node(parameter_one)))
        end
      end
    end
  end
end
