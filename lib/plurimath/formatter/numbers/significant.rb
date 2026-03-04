# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Significant < Base
        attr_accessor :decimal, :significant

        def initialize(symbols)
          setup_accessors(symbols)
          @decimal = symbols[:decimal]
          @significant = symbols[:significant].to_i
        end

        def apply(string, int_format, frac_format)
          return string if significant.zero?
          return string unless string.match?(/[1-9a-f]/)
          chars = string.split("")

          return string if count_chars(chars, true) == significant

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
            new_chars << ("0" * remain_chars) unless frac_part && sig_char_count(new_chars)
          end
          new_chars.join
        end

        def round_str(chars, array, frac_part)
          arr_len = array.length
          char_ind = DIGIT_VALUE.key?(chars[arr_len]) ? arr_len : arr_len.next
          return unless DIGIT_VALUE[chars[char_ind]] >= threshold

          frac_part = false if chars[arr_len] == decimal
          carry  = false
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
              next
            end

            char.next!
            carry = false
            break
          end
          array << "1" if carry
          array.reverse!
        end

        def count_chars(chars, fraction)
          counting = 0
          chars.each do |char|
            break if char == decimal && !fraction

            counting += 1 if DIGIT_VALUE.key?(char)
          end
          counting
        end

        def format_groups(format, string)
          format.format_groups(numeric_string(string, format))
        end

        def numeric_string(string, format)
          string.split(format.separator).join
        end

        def sig_char_count(chars)
          start_counting = false
          counting = 0
          chars.each do |char|
            start_counting = true if DIGIT_VALUE.except("0").key?(char)
            next unless start_counting

            counting += 1 if DIGIT_VALUE.key?(char)
          end
          counting == significant
        end

        def process_chars(chars, sig_num: false, frac_part: false)
          sig_count, sig_num, frac_part = [significant, sig_num, frac_part]
          new_chars = []
          chars.each do |char|
            frac_part ||= char == decimal
            sig_num ||= DIGIT_VALUE.except("0").key?(char)
            break if sig_count.zero?

            new_chars << char
            next unless sig_num
            next unless DIGIT_VALUE.key?(char)

            sig_count -= 1
          end

          [new_chars, frac_part, sig_count]
        end
      end
    end
  end
end
