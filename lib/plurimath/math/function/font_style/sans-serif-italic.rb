# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class FontStyle
        class SansSerifItalic < FontStyle
          # --- Catalog documentation (see Plurimath::Documentation) ---
          DESCRIPTION = "Renders its argument in an italic sans-serif font."
          REFERENCE = "https://en.wikipedia.org/wiki/Mathematical_Alphanumeric_Symbols"
          EXAMPLE = -> { new(sym("x")) }
          # --- end catalog documentation ---

          def to_omml_without_math_tag(display_style, options:)
            font_styles(display_style, sty: "i", scr: "sans-serif",
                                       options: options)
          end
        end
      end
    end
  end
end
