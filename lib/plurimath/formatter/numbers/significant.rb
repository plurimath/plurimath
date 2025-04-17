# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Significant
        attr_accessor :symbols, :decimal, :significant

        def initialize(symbols)
          @symbols = symbols
          @decimal = symbols[:decimal]
          @significant = symbols[:significant].to_i
        end

        def apply(string, int_format, frac_format)
          return string if significant.zero?
          return string unless string.match?(/[1-9]/)
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
          sig_num   = false
          frac_part = false
          new_chars = []
          sig_count = significant
          chars.each_with_index do |char, ind|
            frac_part ||= char == decimal
            sig_num ||= char.match?(/[1-9]/)
            break if sig_count.zero?

            new_chars << char
            next unless sig_num
            next unless char.match?(/[0-9]/)

            sig_count -= 1
          end

          if sig_count > 0
            new_chars << decimal unless frac_part
          else
            remain_chars = count_chars(chars, frac_part) - significant
            if remain_chars > 0
              round_str(chars, new_chars, frac_part)
              remain_chars = 0 if frac_part && remain_chars == 1
            end
            new_chars << ("0" * remain_chars) unless frac_part && sig_char_count(new_chars)
          end
          new_chars.join
        end

        def round_str(chars, array, frac_part)
          arr_len = array.length
          char_ind = chars[arr_len]&.match?(/[0-9]/) ? arr_len : arr_len + 1
          return unless chars[char_ind]&.match?(/[5-9]/)

          frac_part = false if chars[arr_len] == decimal
          prev_ten  = false
          array.reverse!.each_with_index do |char, ind|
            if char == decimal
              array[ind] = ""
              frac_part  = false
              next
            end
            next unless char.match?(/[0-9]/)

            if char == "9"
              prev_ten   = true
              array[ind] = frac_part ? "" : "0"
              next
            end
            char.next!
            prev_ten = false
            break
          end
          array << "1" if prev_ten
          array.reverse!
        end

        def count_chars(chars, fraction)
          counting = 0
          chars.each do |char|
            break if char == decimal && !fraction

            counting += 1 if char.match?(/\d/)
          end
          counting
        end

        def change_format(string, separator, group)
          tokens = []
          tokens << string&.slice!(0, group) until string&.empty?
          tokens.compact.join(separator)
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
            start_counting = true if char.match(/[1-9]/)
            next unless start_counting

            counting += 1 if char.match?(/\d/)
          end
          counting == significant
        end
      end
    end
  end
end
