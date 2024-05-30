# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumberFormatter < TwitterCldr::Formatters::NumberFormatter
      def format(tokens, number, options = {})
        options[:precision] ||= precision_from(number)
        options[:type] ||= :decimal

        prefix, suffix, integer_format, fraction_format = *partition_tokens(tokens)
        number = truncate_number(number, integer_format.format.length)

        int, fraction = parse_number(number, options)
        result = integer_format.apply(int, options)
        result << fraction_format.apply(fraction, options, int) if fraction

        number_system.transliterate(
          "#{prefix.to_s}#{result}#{suffix.to_s}"
        )
      end

      private

      def partition_tokens(tokens)
        [
          token_val_from(tokens[0]),
          token_val_from(tokens[2]),
          Numbers::Integer.new(
            tokens[1],
            data_reader.symbols
          ),
          Numbers::Fraction.new(
            tokens[1],
            data_reader.symbols
          )
        ]
      end
    end
  end
end
