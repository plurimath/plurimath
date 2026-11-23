# frozen_string_literal: true

module Plurimath
  module Math
    module Symbols
      class Symbol
        # Display-tree writers load only when their public entrypoints are used.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing = "", _last = false, _indent = true,
            options:)
            "#{spacing}\"#{to_asciimath(options: options)}\" text\n"
          end

          def to_latex_math_zone(spacing = "", _last = false, _indent = true,
            options:)
            "#{spacing}\"#{to_latex(options: options)}\" text\n"
          end

          def to_omml_math_zone(spacing = "", _last = false, _indent = true,
            display_style:, options:)
            "#{spacing}\"#{dump_omml(self, display_style,
                                     options: options)}\" text\n"
          end

          def to_mathml_math_zone(spacing = "", _last = false, _indent = true,
            options:)
            "#{spacing}\"#{dump_mathml(self, options: options)}\" text\n"
          end

          def to_unicodemath_math_zone(spacing = "", _last = false, _indent = true,
            options:)
            "#{spacing}\"#{to_unicodemath(options: options)}\" text\n"
          end
        end
      end
    end
  end
end
