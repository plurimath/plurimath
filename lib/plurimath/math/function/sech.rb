# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sech < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The hyperbolic secant function."
        REFERENCE = "https://en.wikipedia.org/wiki/Hyperbolic_functions"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

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
