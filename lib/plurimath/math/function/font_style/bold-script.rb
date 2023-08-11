# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class BoldScript < FontStyle
          def to_omml_without_math_tag(display_style)
            font_styles(display_style, sty: "b", scr: "script")
          end
        end
      end
    end
  end
end
