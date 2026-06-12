# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Builds e/scientific/engineering notation while delegating coefficient
      # localization back through the structured renderer.
      class NotationRenderer
        SUPPORTED_NOTATIONS = %i[e scientific engineering].freeze

        def initialize(options)
          @options = options
          @precision = (@options.precision || 0).to_i
          @exponent_sign_renderer = SignRenderer.new(@options.exponent_sign)
        end

        def render(source, notation)
          case notation.to_sym
          when :e
            render_e(source)
          when :scientific
            render_scientific(source)
          when :engineering
            render_engineering(source)
          end
        end

        def self.supported?(notation)
          SUPPORTED_NOTATIONS.include?(notation&.to_sym)
        end

        private

        attr_reader :exponent_sign_renderer, :options, :precision

        def render_e(source)
          localized_notation_parts(source).join(options.exponent_separator.to_s)
        end

        def render_scientific(source)
          localized_notation_parts(source).join(" #{options.times} 10^")
        end

        def render_engineering(source)
          parts = notation_parts(source)
          parts = engineering_notation_parts(parts) unless source.decimal.zero?
          parts[0] = localize_parts(
            source,
            parts[0],
            precision: engineering_precision(source, parts[0]),
          )
          parts.join(" #{options.times} 10^")
        end

        def localize_parts(source, parts, precision:)
          NumberRenderer.new(
            source,
            options,
          ).format_parts(
            parts,
            precision: precision,
          )
        end

        def localized_notation_parts(source)
          parts = notation_parts(source)
          parts[0] = localize_parts(source, parts[0], precision: precision)
          parts[1] = render_exponent(parts[1])
          parts
        end

        def notation_parts(source)
          return [source.to_parts(base: options.base), 0] if source.decimal.zero?

          parts = source.to_parts(base: Base::DEFAULT_BASE)
          digits, exponent = significant_digits_and_exponent(parts)
          [
            Parts.new(
              sign: parts.sign,
              base: options.base,
              integer_digits: digits[0],
              fraction_digits: digits[1..].to_s,
            ),
            exponent,
          ]
        end

        def engineering_notation_parts(parts)
          coefficient, exponent = parts
          index = exponent % 3
          exponent -= index
          digits = "#{coefficient.integer_digits}#{coefficient.fraction_digits}"
          integer_length = index + 1
          integer_digits = digits[0...integer_length].to_s.ljust(integer_length, "0")

          [
            Parts.new(
              sign: coefficient.sign,
              base: options.base,
              integer_digits: integer_digits,
              fraction_digits: digits[integer_length..].to_s,
            ),
            render_exponent(exponent),
          ]
        end

        # The inferred budget covers the source's significant digits; the
        # engineering shift moves up to two of them into the integer part, so
        # the fraction budget must subtract the shifted integer width. Only an
        # explicitly requested precision (including 0) is taken as a literal
        # fraction width.
        def engineering_precision(source, coefficient)
          return precision if options.explicit_precision?
          # Zero sources skip the engineering shift; the resolved precision
          # already carries their stated fraction width.
          return precision if source.decimal.zero?

          integer_length = coefficient.integer_digits.length
          budget = [options.significant, options.digit_count].max
          return [source.significant_digit_count - integer_length, 0].max unless budget.positive?

          fraction_budget = [budget - integer_length, 0].max
          # Leave one digit for Significant's rounding pass when the source
          # carries more digits than the requested budget.
          fraction_budget += 1 if source.significant_digit_count > budget
          fraction_budget
        end

        def significant_digits_and_exponent(parts)
          if parts.integer_zero?
            index = parts.fraction_digits.index(/[1-9]/)
            [parts.fraction_digits[index..], -(index + 1)]
          else
            digits = "#{parts.integer_digits}#{parts.fraction_digits}"
            index = digits.index(/[1-9]/)
            [digits[index..], parts.integer_digits.length - index - 1]
          end
        end

        def render_exponent(exponent)
          return "0" if exponent.zero?

          exponent_sign_renderer.apply(exponent, exponent.abs.to_s)
        end
      end
    end
  end
end
