# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Hom < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The collection of morphisms from one object to another."
        REFERENCE = "https://en.wikipedia.org/wiki/Morphism"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array << r_element("hom", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style, options: options))
          array
        end
      end
    end
  end
end
