# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Applies significant-digit rounding on Parts before localized rendering.
      class Significant < Base
        attr_reader :significant

        CANONICAL_DECIMAL = "."
        EMPTY_STRING = ""
        ZERO = "0"

        def initialize(options)
          super
          @significant = self.options.significant
        end

        def active?
          significant.positive?
        end

        def apply_parts(parts)
          significant_parts(parts)
        end

        protected

        # Apply significant-digit rules before localization so rounding never
        # reparses grouped or decimal-localized output.
        def significant_parts(parts)
          integer = parts.integer_digits
          fraction = parts.fraction_digits
          string = fraction.empty? ? integer : "#{integer}#{CANONICAL_DECIMAL}#{fraction}"
          chars = string.chars
          return parts if skip_significant_processing?(chars)

          integer, fraction = signify(chars).split(CANONICAL_DECIMAL, 2)
          parts.with_digits(
            integer_digits: integer,
            fraction_digits: fraction.to_s,
          )
        end

        def signify(chars)
          new_chars, frac_part, sig_count = process_chars(chars)
          if sig_count.positive?
            new_chars << CANONICAL_DECIMAL unless frac_part
          else
            remain_chars = digit_count(chars, fraction: frac_part) - significant
            if remain_chars.positive?
              round_chars(chars, new_chars, frac_part)
              remain_chars = remaining_fraction_chars(new_chars) if frac_part
            end
            new_chars << (ZERO * remain_chars) unless frac_part && sig_char_count?(new_chars)
          end
          new_chars.join
        end

        def round_chars(chars, result, frac_part)
          char_index = round_char_index(chars, result.length)
          return unless char_index < chars.length && digit_sequence.round_up?(chars[char_index])

          rounded = if frac_part
                      increment_fractional(result.reverse)
                    else
                      increment_integer(result.reverse)
                    end
          result.replace(rounded.reverse)
        end

        def increment_fractional(reversed)
          decimal_index = reversed.index(CANONICAL_DECIMAL)
          return increment_integer(reversed) unless decimal_index

          fraction = reversed[0...decimal_index]
          integer = reversed[(decimal_index + 1)..]
          fraction, carry = digit_sequence.increment_reversed(fraction,
                                                              overflow: EMPTY_STRING)
          return fraction + [CANONICAL_DECIMAL] + integer unless carry.positive?

          integer = increment_integer(integer)
          fraction + [EMPTY_STRING] + integer
        end

        def increment_integer(reversed)
          digits, carry = digit_sequence.increment_reversed(reversed,
                                                            overflow: ZERO)
          digits << "1" if carry.positive?
          digits
        end

        def round_char_index(chars, result_length)
          digit_sequence.digit?(chars[result_length]) ? result_length : result_length.next
        end

        def remaining_fraction_chars(chars)
          return 0 unless chars.include?(CANONICAL_DECIMAL)

          [significant - digit_sequence.significant_digit_count(chars), 0].max
        end

        def digit_count(chars, fraction:)
          stop_at = fraction ? nil : CANONICAL_DECIMAL
          digit_sequence.digit_count(chars, stop_at: stop_at)
        end

        def sig_char_count?(chars)
          digit_sequence.significant_digit_count(chars) == significant
        end

        def process_chars(chars, sig_num: false, frac_part: false)
          sig_count = significant
          new_chars = []
          chars.each do |char|
            frac_part ||= char == CANONICAL_DECIMAL
            sig_num ||= digit_sequence.significant?(char)
            break if sig_count.zero?

            new_chars << char
            next unless sig_num
            next unless digit_sequence.digit?(char)

            sig_count -= 1
          end

          [new_chars, frac_part, sig_count]
        end

        def skip_significant_processing?(chars)
          digit_sequence.significant_digit_count(chars).zero? ||
            digit_count(chars, fraction: true) == significant
        end
      end
    end
  end
end
