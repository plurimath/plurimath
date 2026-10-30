# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sin < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The sine function."
        REFERENCE = "https://en.wikipedia.org/wiki/Sine_and_cosine"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

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
