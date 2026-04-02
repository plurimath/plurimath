# frozen_string_literal: true


module Plurimath
  module Math
    module Function
      class FontStyle
        class BoldItalic < FontStyle
          def to_omml_without_math_tag(display_style, options:)
            font_styles(display_style, sty: "bi", options: options)
          end
        end
      end
    end
  end
end
