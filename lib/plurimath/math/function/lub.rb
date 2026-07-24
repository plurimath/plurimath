# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Lub < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The least upper bound (supremum) of a set."
        REFERENCE = "https://en.wikipedia.org/wiki/Infimum_and_supremum"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def validate_function_formula
          false
        end

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array << r_element("lub", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style, options: options))
          array
        end
      end
    end
  end
end
