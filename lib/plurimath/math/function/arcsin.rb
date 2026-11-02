# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Arcsin < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The inverse sine (arcsine) function."
        REFERENCE = "https://en.wikipedia.org/wiki/Inverse_trigonometric_functions"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          ::Math.asin(evaluator.evaluate_node(parameter_one))
        end
      end
    end
  end
end
