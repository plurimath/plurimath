# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Ln < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The natural logarithm."
        REFERENCE = "https://en.wikipedia.org/wiki/Natural_logarithm"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          ::Math.log(evaluator.evaluate_node(parameter_one))
        end

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array = r_element("ln", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style, options: options))
          array
        end
      end
    end
  end
end
