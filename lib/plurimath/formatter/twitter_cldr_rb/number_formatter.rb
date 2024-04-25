# frozen_string_literal: true

module TwitterCldr
  module Formatters
    class NumberFormatter
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
    end
  end
end
