# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Unitsml
        # Specialized tree writers load on first display use.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing = "", last = false, indent = true,
  options:)
            formula(options).to_asciimath_math_zone(spacing, last, indent,
                                                    options: options)
          end

          def to_latex_math_zone(spacing = "", last = false, indent = true,
  options:)
            formula(options).to_latex_math_zone(spacing, last, indent,
                                                options: options)
          end

          def to_mathml_math_zone(spacing = "", last = false, indent = true,
  options:)
            formula(options).to_mathml_math_zone(spacing, last, indent,
                                                 options: options)
          end

          def to_omml_math_zone(spacing = "", last = false, indent = true,
  options:)
            formula(options).to_omml_math_zone(spacing, last, indent,
                                               options: options)
          end

          def to_unicodemath_math_zone(spacing = "", last = false, indent = true,
  options:)
            formula(options).to_unicodemath_math_zone(spacing, last, indent,
                                                      options: options)
          end
        end
      end
    end
  end
end
