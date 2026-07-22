# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Limsup < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The limit superior of a sequence."
        REFERENCE = "https://en.wikipedia.org/wiki/Limit_inferior_and_limit_superior"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array << r_element("limsup", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style, options: options))
          array
        end
      end
    end
  end
end
