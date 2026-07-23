# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class FontStyle
        class BoldScript < FontStyle
          # --- Catalog documentation (see Plurimath::Documentation) ---
          DESCRIPTION = "Renders its argument in a bold script (calligraphic) font."
          REFERENCE = "https://en.wikipedia.org/wiki/Mathematical_Alphanumeric_Symbols"
          EXAMPLE = -> { new(sym("x")) }
          # --- end catalog documentation ---

          def to_omml_without_math_tag(display_style, options:)
            font_styles(display_style, sty: "b", scr: "script",
                                       options: options)
          end
        end
      end
    end
  end
end
