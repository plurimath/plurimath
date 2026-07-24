# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Cot < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The cotangent function."
        REFERENCE = "https://en.wikipedia.org/wiki/Trigonometric_functions"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

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
