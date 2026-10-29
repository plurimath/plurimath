# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Orchestrates Source and Parts through numeric transforms and final
      # renderers; low-level digit rules stay in composed helpers.
      class NumberRenderer
        attr_reader :options, :source

        def initialize(source, options)
          @source = source
          @options = options
          @base_notation = BaseNotation.from_options(@options)
          @integer_format = Integer.new(@options)
          @fraction_format = Fraction.new(@options)
          @significant_format = Significant.new(@options)
        end

        def format(precision: nil)
          render_precision = precision || options.precision || source_precision
          parts = source.to_parts(
            base: options.base,
            precision: decimal_precision_for(render_precision),
          )
          format_parts(parts, precision: render_precision)
        end

        def format_parts(parts, precision:)
          decimal_precision = decimal_precision_for(precision)
          unless decimal_precision.nil?
            parts = parts.with_digits(
              fraction_digits: parts.fraction_digits[0...decimal_precision.to_i].to_s,
            )
          end
          parts = renderable_parts(parts, precision: precision)

          parts = significant_format.apply_parts(parts) if significant_format.active?

          FormattedNumber.new(
            sign: parts.sign,
            integer_part: integer_format.format_groups(parts.integer_digits),
            fraction_part: parts.fractional? ? fraction_format.format_groups(parts.fraction_digits) : "",
            decimal_separator: fraction_format.decimal,
            base_notation: base_notation,
            number_sign: options.number_sign,
          )
        end

        private

        attr_reader :base_notation, :fraction_format, :integer_format,
                    :significant_format

        def renderable_parts(parts, precision:)
          parts = parts.with_digits(
            integer_digits: integer_format.number_to_base(parts.integer_digits),
          )
          fraction_format.apply_parts(parts, precision: precision)
        end

        def source_precision
          return 0 if source.decimal.fix == source.decimal

          source.fraction_digits.length
        end

        # Precision budgets target-base digits, so the decimal fraction must
        # stay intact until Fraction#change_base generates them; truncating
        # decimal digits first loses value (0.07 in hex became 0x0.0).
        def decimal_precision_for(precision)
          return precision if options.base == Base::DEFAULT_BASE

          nil
        end
      end
    end
  end
end
