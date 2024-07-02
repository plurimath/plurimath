# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Significant# < Plurimath::Formatter::NumberFormatter
        attr_accessor :symbols, :decimal, :significant

        def initialize(symbols)
          @symbols = symbols
          @decimal = symbols[:decimal]
          @significant = symbols[:significant].to_i
        end

        def apply(string, int_format, frac_format)
          return string if significant.zero?
          return string unless string.match?(/[1-9]/)

          string = signify(string.split(""))
          integer, frac_part = string.split(decimal)
          string = [int_format.format_groups(integer.split(int_format.separator).join)]
          string << frac_format.send("change_format", frac_part.split(frac_format.separator).join) if frac_part
          string.join(decimal)
        end

        private

        def signify(chars)
          new_array = []
          sig_num   = false
          frac_part = false
          sig_count = significant
          chars.each.with_index do |char, ind|
            frac_part = frac_part || char == decimal
            sig_num = sig_num || char.match?(/[1-9]/)
            break if sig_count.zero?

            new_array << char
            next unless sig_num
            next unless char.match?(/[0-9]/)

            sig_count -= 1
          end

          if sig_count > 0
            new_array << decimal unless frac_part
            new_array << ("0" * sig_count)
          else
            remain_chars = count_chars(chars, frac_part) - significant
            round_str(chars, new_array, frac_part) if remain_chars > 0
            remain_chars = 0 if frac_part && remain_chars == 1
            new_array << ("0" * remain_chars)
          end
          new_array.join
        end

        def round_str(chars, new_array, frac_part)
          arr_len = new_array.length
          char_ind = chars[arr_len]&.match?(/[0-9]/) ? arr_len : arr_len + 1
          return unless chars[char_ind]&.match?(/[5-9]/)

          frac_part = false if chars[arr_len] == decimal
          prev_ten  = false
          new_array.reverse!.each.with_index do |char, ind|
            if char == decimal
              new_array[ind] = ""
              frac_part = false

              next
            end
            next unless char.match?(/[0-9]/)

            if char.match?(/[0-8]/)
              char.next!
              prev_ten = false

              break
            else
              new_array[ind] = frac_part ? "" : "0"
              prev_ten = true
            end
          end
          new_array << "1" if prev_ten
          new_array.reverse!
        end

        def count_chars(chars, frac_part)
          counting = 0
          chars.find_all do |char|
            break if char == decimal && !frac_part

            counting += 1 if char.match?(/\d/)
          end
          counting
        end

        def change_format(string, separator, group)
          tokens = []
          tokens << string&.slice!(0, group) until string&.empty?
          tokens.compact.join(separator)
        end
      end
    end
  end
end
