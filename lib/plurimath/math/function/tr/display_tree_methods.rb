# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Tr
        # Specialized tree writers load on first display use.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing, last = false, indent = true,
  options:)
            [
              "#{spacing}\"tr\" function apply\n",
              Formula.new(parameter_one).to_asciimath_math_zone(
                gsub_spacing(spacing, last), last, indent, options: options
              ),
            ]
          end

          def to_latex_math_zone(spacing, last = false, indent = true, options:)
            [
              "#{spacing}\"tr\" function apply\n",
              Formula.new(parameter_one).to_latex_math_zone(
                gsub_spacing(spacing, last), last, indent, options: options
              ),
            ]
          end

          def to_mathml_math_zone(spacing, last = false, indent = true, options:)
            [
              "#{spacing}\"tr\" function apply\n",
              Formula.new(parameter_one).to_mathml_math_zone(
                gsub_spacing(spacing, last), last, indent, options: options
              ),
            ]
          end

          def to_omml_math_zone(spacing, last = false, indent = true,
  display_style:, options:)
            [
              "#{spacing}\"tr\" function apply\n",
              Formula.new(parameter_one).to_omml_math_zone(
                gsub_spacing(spacing,
                             last), last, indent, display_style: display_style, options: options
              ),
            ]
          end

          def to_unicodemath_math_zone(spacing, last = false, indent = true,
  options:)
            [
              "#{spacing}\"tr\" function apply\n",
              Formula.new(parameter_one).to_unicodemath_math_zone(
                gsub_spacing(spacing, last), last, indent, options: options
              ),
            ]
          end
        end
      end
    end
  end
end
