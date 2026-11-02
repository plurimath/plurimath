# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Cos < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The cosine function."
        REFERENCE = "https://en.wikipedia.org/wiki/Sine_and_cosine"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

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
