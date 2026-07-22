# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Min < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The minimum of a set."
        REFERENCE = "https://en.wikipedia.org/wiki/Maximum_and_minimum"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def validate_function_formula
          false
        end

        def evaluate(evaluator)
          evaluator.function_arguments(parameter_one).min
        end

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array << r_element("min", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style, options: options))
          array
        end
      end
    end
  end
end
