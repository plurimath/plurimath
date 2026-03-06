# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Significant < Base
        attr_accessor :decimal, :significant

        def initialize(symbols)
          super
          @decimal = symbols[:decimal]
          @significant = symbols[:significant].to_i
        end

        def apply(string, int_format, frac_format)
          return string if significant.zero?
          # Check if string contains any non-zero digit (works across all bases 2-16)
          chars = string.chars
          return string if skip_significant_processing?(chars)

          string = signify(chars)
          integer, fraction = string.split(decimal)
          string = [format_groups(int_format, integer)]
          string << format_groups(frac_format, fraction) if fraction
          string.join(decimal)
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
              remain_chars = 0 if frac_part && remain_chars == 1
            end
            new_chars << ("0" * remain_chars) unless frac_part && sig_char_count?(new_chars)
          end
          new_chars.join
        end

        def round_str(chars, array, frac_part)
          arr_len = array.length
          char_ind = DIGIT_VALUE.key?(chars[arr_len]) ? arr_len : arr_len.next
          return unless char_ind < chars.length && DIGIT_VALUE[chars[char_ind]] >= threshold

          frac_part = false if chars[arr_len] == decimal
          carry = false
          array.reverse!.each_with_index do |char, ind|
            if char == decimal
              array[ind] = ""
              frac_part  = false
              next
            end
            next unless DIGIT_VALUE.key?(char)

            if DIGIT_VALUE[char] == base.pred
              carry = true
              array[ind] = frac_part ? "" : "0"
            else
              array[ind] = next_mapping_char(char)
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

            char_count += 1 if DIGIT_VALUE.key?(char)
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
            start_counting = true if DIGIT_VALUE[char]&.positive?
            next unless start_counting

            char_count += 1 if DIGIT_VALUE.key?(char)
          end
          char_count == significant
        end

        def process_chars(chars, sig_num: false, frac_part: false)
          sig_count = significant
          new_chars = []
          chars.each do |char|
            frac_part ||= char == decimal
            sig_num ||= DIGIT_VALUE[char]&.positive?
            break if sig_count.zero?

            new_chars << char
            next unless sig_num
            next unless DIGIT_VALUE.key?(char)

            sig_count -= 1
          end

          [new_chars, frac_part, sig_count]
        end

        def skip_significant_processing?(chars)
          # Skip if no significant digits exist, or if we already have the exact count needed
          chars.none? { |c| DIGIT_VALUE.key?(c) && DIGIT_VALUE[c].positive? } ||
            count_chars(chars, true) == significant
        end
      end
    end
  end
end
