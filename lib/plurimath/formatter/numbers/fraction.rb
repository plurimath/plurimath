# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Fraction < Base
        attr_reader :decimal, :precision, :separator, :group

        DEFAULT_PRECISION = 3
        DEFAULT_STRINGS = { empty: "", zero: "0", dot: ".", f: "F" }.freeze

        def initialize(symbols = {})
          setup_accessors(symbols)
          @group       = symbols[:fraction_group_digits]
          @decimal     = symbols.fetch(:decimal, DEFAULT_STRINGS[:dot])
          @int_group   = symbols[:group]
          @separator   = symbols[:fraction_group].to_s
          @precision   = symbols.fetch(:precision, DEFAULT_PRECISION)
          @digit_count = symbols[:digit_count]
        end

        def apply(fraction, options = {}, result, integer_formatter)
          precision = options[:precision] || @precision
          @result = result
          @integer_formatter = integer_formatter
          return DEFAULT_STRINGS[:empty] unless precision > 0

          fraction = change_base(fraction) if fraction.match?(/[1-9]/)

          number = if @digit_count
                     digit_count_format(fraction)
                   else
                     format(fraction, precision)
                   end
          formatted_number = format_groups(number) if number && !number.empty?
          formatted_number ? decimal + formatted_number : DEFAULT_STRINGS[:empty]
        end

        def format(number, precision)
          return number if precision <= number.length

          number + DEFAULT_STRINGS[:zero] * (precision - number.length)
        end

        def format_groups(string, length = group)
          length = string.length if group.to_i.zero?

          change_format(string, length)
        end

        protected

        def change_format(string, length)
          tokens = []
          tokens << string&.slice!(0, length) until string&.empty?
          tokens.compact.join(separator)
        end

        def digit_count_format(fraction)
          integer = raw_integer + DEFAULT_STRINGS[:dot] + fraction
          int_length = integer.length.pred # integer length; excluding the decimal point
          if int_length > @digit_count
            round_base_string(fraction)
          elsif int_length < @digit_count
            fraction + (DEFAULT_STRINGS[:zero] * (update_digit_count(fraction) - int_length))
          else
            fraction
          end
        end

        def update_digit_count(number)
          return @digit_count unless zeros_count_in(number) == @precision

          @digit_count - @precision.next
        end

        def zeros_count_in(number)
          return unless number.split('').all? { |digit| digit == DEFAULT_STRINGS[:zero] }

          number.length
        end

        def round_base_string(fraction)
          digits = fraction[0..frac_digit_count].split("")
          discard_char = digits.pop
          return digits.join if DIGIT_VALUE[discard_char] < threshold

          carry = 1
          rounded_reversed = []
          digits.reverse_each do |digit|
            next rounded_reversed << digit unless carry.positive?

            rounded_reversed << if DIGIT_VALUE[digit] == base.pred
              DEFAULT_STRINGS[:zero]
            else
              carry = 0
              next_mapping_char(digit)
            end
          end

          round_integer(rounded_reversed, carry) if carry.positive?
          rounded_reversed.reverse.join unless rounded_reversed.empty?
        end

        def round_integer(fraction_digits_reversed, carry = 1)
          incremented, carry = increment_integer_digits(@result[0].split(""), carry)
          @result[0] = if carry.positive?
                         fraction_digits_reversed.pop
                         @integer_formatter.format_groups("1#{incremented}")
                       else
                         incremented
                       end
        end

        def increment_integer_digits(int_digits, carry)
          int_digits.reverse!
          str_chars = [decimal, @int_group]
          int_digits.each_with_index do |digit, index|
            next if str_chars.include?(digit)

            if DIGIT_VALUE[digit] == base.pred
              int_digits[index] = DEFAULT_STRINGS[:zero]
            else
              int_digits[index] = next_mapping_char(digit)
              break carry = 0
            end
          end

          [int_digits.reverse!.join, carry]
        end

        def change_base(number)
          # Represent the fractional part exactly as a rational number to avoid
          # binary floating-point rounding errors when converting bases.
          fraction = Rational(number.to_i, 10**number.length)

          base_result = []
          digits = @precision || number.length

          digits.times do
            fraction *= base
            digit = fraction.to_i
            base_result << HEX_ALPHANUMERIC[digit]
            fraction -= digit
          end

          base_result.join
        end

        def raw_integer
          @result[0].delete(@int_group)
        end

        def frac_digit_count
          @digit_count - raw_integer.length
        end
      end
    end
  end
end
