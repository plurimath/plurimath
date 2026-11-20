# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Text
        # Specialized tree writers load on first display use.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing, _, _, options:)
            "#{spacing}#{to_asciimath(options: options)} text\n"
          end

          def to_latex_math_zone(spacing, _, _, options:)
            "#{spacing}#{to_asciimath(options: options)} text\n"
          end

          def to_mathml_math_zone(spacing, _, _, options:)
            "#{spacing}\"#{dump_mathml(self, options: options)}\" text\n"
          end

          def to_omml_math_zone(spacing, _, _, display_style:, options:)
            "#{spacing}\"#{dump_omml(self, display_style,
                                     options: options)}\" text\n"
          end

          def to_unicodemath_math_zone(spacing, _, _, options:)
            "#{spacing}#{to_unicodemath(options: options)} text\n"
          end
        end
      end
    end
  end
end
