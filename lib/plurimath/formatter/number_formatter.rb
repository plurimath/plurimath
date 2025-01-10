# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumberFormatter
      attr_reader :number, :data_reader, :prefix

      STRING_SYMBOLS = {
        dot: ".".freeze,
        f: "F".freeze,
      }.freeze

      def initialize(number, data_reader = {})
        @number = number
        @data_reader = data_reader
        @prefix = "-" if number.negative?
      end

      def format(precision: nil)
        data_reader[:precision] = precision || precision_from(number)
        int, frac, integer_format, fraction_format, signif_format = *partition_tokens(number)
        # FIX FOR:
        #   NotImplementedError: String#<< not supported. Mutable String methods are not supported in Opal.
        result = []
        result << integer_format.apply(int, data_reader)
        result << fraction_format.apply(frac, data_reader, int) if frac
        result = result.join
        result = signif_format.apply(result, integer_format, fraction_format)
        result = "+#{result}" if number.positive? && data_reader[:number_sign].to_s == "plus"
        "#{prefix}#{result}"
      end

      private

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

        num = if precision == 0
                round_to(number, precision).abs.fix.to_s(STRING_SYMBOLS[:f])
              else
                round_to(number, precision).abs.round(precision).to_s(STRING_SYMBOLS[:f])
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
