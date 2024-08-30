# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class BoldSansSerif < FontStyle
          def to_omml_without_math_tag(display_style, options:)
            font_styles(display_style, sty: "b", scr: "sans-serif", options: options)
          end
        end
      end
    end
  end
end
