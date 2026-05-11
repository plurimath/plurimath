# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumberFormatter
      attr_reader :number, :options

      def initialize(number, options = {})
        @number = number
        @options = Numbers::FormatOptions.coerce(options)
        @source = Numbers::Source.new(number.to_s("F"))
        @base_notation = Numbers::BaseNotation.new(@options)
        @integer_format = Numbers::Integer.new(@options)
        @fraction_format = Numbers::Fraction.new(@options)
        @significant_format = Numbers::Significant.new(@options)
        @parts_renderer = Numbers::PartsRenderer.new(
          integer_formatter: @integer_format,
          fraction_formatter: @fraction_format,
        )
        @sign_renderer = Numbers::SignRenderer.new(@options)
      end

      def format(precision: nil)
        options.precision = precision || options.precision || source_precision
        parts = source.to_parts(
          base: options.base,
          precision: options.precision,
        )
        parts = renderable_parts(parts)

        parts = significant_format.apply_parts(parts) if significant_format.active?
        result = parts_renderer.render(parts)

        sign_renderer.apply(parts, base_notation.apply(result))
      end

      private

      attr_reader :base_notation, :fraction_format, :integer_format,
                  :parts_renderer, :significant_format, :sign_renderer, :source

      def renderable_parts(parts)
        parts = parts.with_digits(
          integer_digits: integer_format.number_to_base(parts.integer_digits),
        )
        fraction_format.apply_parts(parts)
      end

      def source_precision
        return 0 if number.fix == number

        source.fraction_digits.length
      end
    end
  end
end
