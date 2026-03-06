# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumberFormatter
      attr_reader :number, :data_reader

      DEFAULT_BASE = 10
      STRING_SYMBOLS = {
        dot: ".",
        f: "F",
      }.freeze
      DEFAULT_BASE_PREFIXES = {
        2 => "0b",
        8 => "0o",
        10 => "",
        16 => "0x",
      }.freeze

      def initialize(number, data_reader = {})
        @number = number
        @data_reader = data_reader
        @base = data_reader[:base] || DEFAULT_BASE
        raise UnsupportedBase.new(@base, DEFAULT_BASE_PREFIXES) unless DEFAULT_BASE_PREFIXES.key?(@base)

        # Handle base_prefix: if explicitly provided (even as nil), use it; otherwise use default
        @base_prefix = if data_reader.key?(:base_prefix)
                         data_reader[:base_prefix].to_s
                       else
                         DEFAULT_BASE_PREFIXES[@base]
                       end
      end

      def format(precision: nil)
        data_reader[:precision] = precision || precision_from(number)
        int, frac, integer_format, fraction_format, signif_format = *partition_tokens(number)
        # FIX FOR:
        #   NotImplementedError: String#<< not supported. Mutable String methods are not supported in Opal.
        result = []
        result << integer_format.apply(int)
        result << fraction_format.apply(frac, data_reader, result, integer_format) # use formatted int for correct fraction formatting
        result = result.join
        result = signif_format.apply(result, integer_format, fraction_format)
        result = result.upcase if upcase_hex?
        result = pre_post_fixed(result) unless base_default?
        "#{prefix_symbol}#{result}"
      end

      private

      def upcase_hex?
        @base == 16 && data_reader[:hex_capital]
      end

      def prefix_symbol
        if number.negative?
          "-"
        elsif data_reader[:number_sign]&.to_sym == :plus
          "+"
        end
      end

      def pre_post_fixed(result)
        if data_reader.key?(:base_postfix)
          "#{result}#{data_reader[:base_postfix]}"
        else
          "#{@base_prefix}#{result}"
        end
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
        num = if precision == 0
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

      def base_default?
        @base == DEFAULT_BASE
      end
    end
  end
end
