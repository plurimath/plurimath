# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Uncertainty
        # Specialized tree writers load on first display use.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing = "", _last = false, _indent = true,
                                     options:)
            "#{spacing}#{to_asciimath(options: options)} uncertainty\n"
          end

          def to_latex_math_zone(spacing = "", _last = false, _indent = true,
                                 options:)
            "#{spacing}\"#{to_latex(options: options)}\" uncertainty\n"
          end

          def to_mathml_math_zone(spacing = "", _last = false, _indent = true,
                                  options:)
            "#{spacing}\"#{dump_mathml(self, options: options)}\" uncertainty\n"
          end

          def to_omml_math_zone(spacing = "", _last = false, _indent = true,
                                display_style:, options:)
            "#{spacing}\"#{dump_omml(self, display_style,
                                     options: options)}\" uncertainty\n"
          end

          def to_unicodemath_math_zone(spacing = "", _last = false,
                                       _indent = true, options:)
            "#{spacing}\"#{to_unicodemath(options: options)}\" uncertainty\n"
          end
        end
      end
    end
  end
end
