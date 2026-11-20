# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Fenced
        # Specialized tree writers load on first display use.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing, last = false, indent = true,
  options:)
            filtered_values(parameter_two,
                            lang: :asciimath).map.with_index(1) do |object, index|
              new_last = index == @values.length && last
              object.to_asciimath_math_zone(spacing, new_last, indent,
                                            options: options)
            end
          end

          def to_latex_math_zone(spacing, last = false, indent = true, options:)
            filtered_values(parameter_two,
                            lang: :latex).map.with_index(1) do |object, index|
              new_last = index == @values.length && last
              object.to_latex_math_zone(spacing, new_last, indent,
                                        options: options)
            end
          end

          def to_mathml_math_zone(spacing, last = false, indent = true, options:)
            filtered_values(parameter_two, lang: :mathml,
                                           options: options).map.with_index(1) do |object, index|
              new_last = index == @values.length && last
              object.to_mathml_math_zone(spacing, new_last, indent,
                                         options: options)
            end
          end

          def to_omml_math_zone(spacing, last = false, indent = true,
  display_style:, options:)
            filtered_values(parameter_two, lang: :omml).map do |object|
              object.to_omml_math_zone(spacing, last, !indent,
                                       display_style: display_style, options: options)
            end
          end

          def to_unicodemath_math_zone(spacing, last = false, indent = true,
  options:)
            filtered_values(parameter_two,
                            lang: :unicodemath).map.with_index(1) do |object, index|
              new_last = index == @values.length && last
              object.to_unicodemath_math_zone(spacing, new_last, indent,
                                              options: options)
            end
          end
        end
      end
    end
  end
end
