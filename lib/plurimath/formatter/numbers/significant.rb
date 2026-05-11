# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Significant < Base
        attr_accessor :decimal, :significant

        CANONICAL_DECIMAL = "."

        def initialize(symbols)
          super
          @decimal = symbols[:decimal]
          @significant = symbols[:significant].to_i
        end

        def apply(string, int_format, frac_format)
          return string if significant.zero?

          chars = string.chars
          return string if skip_significant_processing?(chars)

          string = signify(chars)
          integer, fraction = string.split(decimal)
          string = [format_groups(int_format, integer)]
          string << format_groups(frac_format, fraction) if fraction
          string.join(decimal)
        end

        def active?
          significant.positive?
        end

        def apply_parts(integer, fraction)
          previous_decimal = decimal
          self.decimal = CANONICAL_DECIMAL
          string = fraction.empty? ? integer : "#{integer}#{decimal}#{fraction}"
          chars = string.chars
          return [integer, fraction] if skip_significant_processing?(chars)

          integer, fraction = signify(chars).split(decimal, 2)
          [integer, fraction.to_s]
        ensure
          self.decimal = previous_decimal
        end

        protected

        def signify(chars)
          new_chars, frac_part, sig_count = process_chars(chars)
          if sig_count.positive?
            new_chars << decimal unless frac_part
          else
            remain_chars = count_chars(chars, frac_part) - significant
            if remain_chars.positive?
              round_str(chars, new_chars, frac_part)
              if frac_part
                has_decimal = new_chars.include?(decimal)
                if has_decimal
                  actual_sig = count_significant_digits(new_chars)
                  remain_chars = [significant - actual_sig, 0].max
                else
                  remain_chars = 0
                  frac_part = false
                end
              end
            end
            new_chars << ("0" * remain_chars) unless frac_part && sig_char_count?(new_chars)
          end
          new_chars.join
        end

        def round_str(chars, array, frac_part)
          arr_len = array.length
          char_ind = digit_sequence.digit?(chars[arr_len]) ? arr_len : arr_len.next
          return unless char_ind < chars.length && digit_sequence.round_up?(chars[char_ind])

          frac_part = false if chars[arr_len] == decimal
          carry = false
          array.reverse!.each_with_index do |char, ind|
            if char == decimal
              array[ind] = ""
              frac_part  = false
              next
            end
            next unless digit_sequence.digit?(char)

            if digit_sequence.max_digit?(char)
              carry = true
              array[ind] = frac_part ? "" : "0"
            else
              array[ind] = digit_sequence.next_digit(char)
              carry = false
              break
            end
          end
          array << "1" if carry
          array.reverse!
        end

        def count_chars(chars, fraction)
          char_count = 0
          chars.each do |char|
            break if char == decimal && !fraction

            char_count += 1 if digit_sequence.digit?(char)
          end
          char_count
        end

        def format_groups(format, string)
          format.format_groups(numeric_string(string, format))
        end

        def numeric_string(string, format)
          string.split(format.separator).join
        end

        def sig_char_count?(chars)
          start_counting = false
          char_count = 0
          chars.each do |char|
            start_counting = true if digit_sequence.significant?(char)
            next unless start_counting

            char_count += 1 if digit_sequence.digit?(char)
          end
          char_count == significant
        end

        def process_chars(chars, sig_num: false, frac_part: false)
          sig_count = significant
          new_chars = []
          chars.each do |char|
            frac_part ||= char == decimal
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
          chars.none? { |c| digit_sequence.significant?(c) } ||
            count_chars(chars, true) == significant
        end

        def count_significant_digits(chars)
          start_counting = false
          char_count = 0
          chars.each do |char|
            start_counting = true if digit_sequence.significant?(char)
            next unless start_counting

            char_count += 1 if digit_sequence.digit?(char)
          end
          char_count
        end
      end
    end
  end
end
