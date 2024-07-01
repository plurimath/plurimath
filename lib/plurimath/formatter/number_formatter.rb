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

        result = sigfigs(result) unless significant.zero?

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

      def sigfigs(str)
        return str unless str.match?(/[1-9]/)

        signify_fraction(str)
      end

      def signify_fraction(str)
        chars = str.chars
        sig_num = false
        sig_count = significant
        frac_part = false
        new_str = chars.map.with_index do |char, ind|
          if char == decimal_char
            frac_part = true
          elsif sig_count.zero?
            next if frac_part

            next "0"
          elsif sig_num
            sig_count -= 1
            round_str(chars, ind, frac_part) if sig_count.zero?
          elsif char.match?(/[1-9]/)
            sig_num = true
            sig_count -= 1
          end
          char
        end.join
        if sig_count > 0
          decimal = frac_part ? "" : decimal_char
          new_str << (decimal + ("0" * sig_count))
        end
        new_str
      end

      def decimal_char
        data_reader.symbols[:decimal]
      end

      def significant
        data_reader.symbols[:significant] || 0
      end

      def round_str(chars, index, frac_part)
        plus_one = false
        chars.reverse.each.with_index do |char, ind|
          next char unless index >= ind

          if char == "9" && plus_one
          elsif plus_one
          elsif char.match?(/[5-9]/)
          else
            next char
          end
        end
      end
    end
  end
end
