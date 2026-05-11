# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumberFormatter
      attr_reader :number, :data_reader

      DEFAULT_BASE = Numbers::Base::DEFAULT_BASE
      STRING_SYMBOLS = {
        dot: ".",
        f: "F",
      }.freeze
      DEFAULT_BASE_PREFIXES = Numbers::BaseNotation::DEFAULT_PREFIXES

      def initialize(number, data_reader = {})
        @number = number
        @data_reader = data_reader
        @base_notation = Numbers::BaseNotation.new(data_reader)
        @sign_renderer = Numbers::SignRenderer.new(data_reader[:number_sign])
      end

      def format(precision: nil)
        data_reader[:precision] = precision || precision_from(number)
        int, frac, integer_format, fraction_format, signif_format = *partition_tokens(number)
        return format_significant(int, frac, integer_format, fraction_format, signif_format) if signif_format.active?

        # FIX FOR:
        #   NotImplementedError: String#<< not supported. Mutable String methods are not supported in Opal.
        result = []
        result << integer_format.apply(int)
        result << fraction_format.apply(frac, result, integer_format) # use formatted int for correct fraction formatting
        result = result.join
        result = signif_format.apply(result, integer_format, fraction_format)
        sign_renderer.apply(number, base_notation.apply(result))
      end

      private

      attr_reader :base_notation, :sign_renderer

      def format_significant(
        int,
        fraction,
        integer_format,
        fraction_format,
        significant_format
      )
        int = integer_format.number_to_base(int)
        int, fraction = fraction_format.raw_digits(fraction, int)
        int, fraction = significant_format.apply_parts(int, fraction)

        result = integer_format.format_groups(int)
        formatted_fraction = fraction_format.format_groups(fraction) unless fraction.empty?
        result = "#{result}#{fraction_format.decimal}#{formatted_fraction}" if formatted_fraction
        sign_renderer.apply(number, base_notation.apply(result))
      end

      def partition_tokens(number)
        int, fraction = parse_number(number)
        [
          int,
          fraction,
          Numbers::Integer.new(data_reader),
          Numbers::Fraction.new(data_reader),
          Numbers::Significant.new(data_reader),
        ]
      end

      def precision_from(number)
        return 0 if number.fix == number

        parts = number.to_s(STRING_SYMBOLS[:f]).split(STRING_SYMBOLS[:dot])
        parts.size == 2 ? parts[1].size : 0
      end

      def parse_number(number, options = data_reader)
        precision = options[:precision] || precision_from(number)

        abs = round_to(number, precision).abs
        num = if precision.zero?
                abs.fix.to_s(STRING_SYMBOLS[:f])
              else
                abs.round(precision).to_s(STRING_SYMBOLS[:f])
              end
        num.split(STRING_SYMBOLS[:dot])
      end

      def round_to(number, precision)
        factor = BigDecimal(10).power(precision)
        (number * factor).fix / factor
      end
    end
  end
end
