# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Lg < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The base-10 (common) logarithm."
        REFERENCE = "https://en.wikipedia.org/wiki/Common_logarithm"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          ::Math.log10(evaluator.evaluate_node(parameter_one))
        end

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array << r_element("lg", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style, options: options))
          array
        end
      end
    end
  end
end
