# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Ker < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The kernel of a homomorphism or linear map."
        REFERENCE = "https://en.wikipedia.org/wiki/Kernel_(algebra)"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array << r_element("ker", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style, options: options))
          array
        end
      end
    end
  end
end
