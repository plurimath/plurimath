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
        new_array = []
        chars.each.with_index do |char, ind|
          frac_part = frac_part || char == decimal_char
          sig_num = sig_num || char.match?(/[1-9]/)

          break if sig_count.zero?

          new_array << char
          next unless sig_num || char.match?(/[0-9]/)

          sig_count -= 1
        end
        if sig_count > 0
          new_array << decimal_char unless frac_part
          new_array << ("0" * sig_count)
        else
          remain_chars = chars.length - significant
          round_str(chars, new_array, frac_part) if remain_chars > 0
          new_array << ("0" * remain_chars)
        end
        new_array
      end

      def decimal_char
        data_reader.symbols[:decimal]
      end

      def significant
        data_reader.symbols[:significant] || 0
      end

      def round_str(chars, new_array, frac_part)
        return unless chars[new_array.length].match?(/[5-9]/)

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
