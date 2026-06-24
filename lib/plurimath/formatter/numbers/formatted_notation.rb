# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Structured result of notation formatting (e, scientific, engineering).
      # Carries the coefficient as a FormattedNumber, the exponent as an
      # integer, and notation style metadata so output renderers (MathML,
      # LaTeX, etc.) can produce structured representations instead of flat
      # strings.
      class FormattedNotation
        STYLES = %i[e scientific engineering].freeze

        attr_reader :coefficient, :notation_style, :exponent,
                    :times_symbol, :exponent_separator, :exponent_sign

        def initialize(
          coefficient:,
          notation_style:,
          exponent:,
          times_symbol: "×",
          exponent_separator: "e",
          exponent_sign: nil
        )
          @coefficient = coefficient
          @notation_style = notation_style
          @exponent = exponent
          @times_symbol = times_symbol
          @exponent_separator = exponent_separator
          @exponent_sign = exponent_sign
        end

        def to_s
          case notation_style
          when :e
            "#{coefficient}#{exponent_separator}#{formatted_exponent}"
          when :scientific, :engineering
            "#{coefficient} #{times_symbol} 10^#{formatted_exponent}"
          end
        end

        def to_str
          to_s
        end

        def base_notation?
          coefficient.base_notation?
        end

        # The exponent rendered as a string, applying sign conventions.
        # Public so that output renderers can access it directly.
        def formatted_exponent
          return "0" if exponent.zero?

          sign_prefix = exponent_sign == :plus ? "+" : nil
          abs_exp = exponent.abs.to_s
          exponent.negative? ? "-#{abs_exp}" : "#{sign_prefix}#{abs_exp}"
        end
      end
    end
  end
end
