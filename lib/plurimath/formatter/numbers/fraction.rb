# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Fraction
        attr_reader :decimal, :precision, :separator, :group, :base

        DEFAULT_PRECISION = 3
        DEFAULT_STRINGS = { empty: "", zero: "0", dot: ".", f: "F" }.freeze

        include Round

        def initialize(symbols = {})
          @base        = symbols[:base] || DEFAULT_BASE
          @group       = symbols[:fraction_group_digits]
          @decimal     = symbols.fetch(:decimal, DEFAULT_STRINGS[:dot])
          @int_group   = symbols[:group]
          @separator   = symbols[:fraction_group].to_s
          @precision   = symbols.fetch(:precision, DEFAULT_PRECISION)
          @digit_count = symbols[:digit_count]
        end

        def apply(fraction, options = {}, result)
          precision = options[:precision] || @precision
          @result = result
          return DEFAULT_STRINGS[:empty] unless precision > 0

          fraction = convert_to_base(fraction) if fraction.match?(/[1-9]/)

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

        def convert_to_base(fraction)
          return fraction if base_default?

          frac = change_base(fraction)
          return frac unless fraction.start_with?(DEFAULT_STRINGS[:zero])

          "#{fraction.match(/^#{DEFAULT_STRINGS[:zero]}+/)}#{frac}" # preserve leading zeros from fraction
        end

        def change_format(string, length)
          tokens = []
          tokens << string&.slice!(0, length) until string&.empty?
          tokens.compact.join(separator)
        end

        def digit_count_format(fraction)
          integer = raw_integer + DEFAULT_STRINGS[:dot] + fraction
          int_length = integer.length - 1 # integer length; excluding the decimal point
          @digit_count ||= int_length
          if int_length > @digit_count
            number_string = round_integer_for_base(integer, fraction)
            number_string = numeric_digits(number_string) if @digit_count > raw_integer.length && base_default?
            number_string
          elsif int_length < @digit_count
            fraction + (DEFAULT_STRINGS[:zero] * (update_digit_count(fraction) - int_length))
          else
            fraction
          end
        end

        def numeric_digits(float)
          frac_count = @digit_count - raw_integer.length
          return float if float.length == frac_count
          return unless frac_count > float.length

          float + (DEFAULT_STRINGS[:zero] * frac_count)
        end

        def update_digit_count(number)
          return @digit_count unless zeros_count_in(number) == @precision

          @digit_count - @precision + 1
        end

        def zeros_count_in(number)
          return unless number.split('').all? { |digit| digit == DEFAULT_STRINGS[:zero] }

          number.length
        end

        def round_integer_for_base(integer, fraction)
          round_value = @digit_count - raw_integer.length
          return unless round_value >= 0

          round_base_string(fraction, round_value)
        end

        def round_base_string(fraction, keep)
          return fraction if fraction.length < keep

          threshold = @base.div(2) # 1, 4, 5, 8 for bases 2, 8, 10, 16
          digits = fraction[0..keep].split("")
          discard_char = digits.pop

          return digits.join if DIGIT_VALUE[discard_char] < threshold

          carry = 1
          rounded_reversed = []
          digits.reverse_each do |digit|
            next(rounded_reversed << digit) unless carry.positive?

            rounded_digit, carry = round_digit(digit, threshold)
            rounded_reversed << rounded_digit
          end

          round_integer(rounded_reversed, threshold, carry) if carry.positive?
          rounded_reversed.reverse.join unless rounded_reversed.empty?
        end

        def round_integer(fraction_digits_reversed, threshold, carry = 1)
          int_digits = raw_integer.split("")
          next_digit = DIGIT_VALUE[int_digits.last.next]

          @result[0] =
            if next_digit.nil? || next_digit >= threshold
              incremented, carry = increment_integer_digits(int_digits, threshold, carry)
              if carry.positive?
                fraction_digits_reversed.pop
                "1#{incremented}"
              else
                incremented
              end
            else
              raw_integer.next
            end
        end

        def increment_integer_digits(int_digits, threshold, carry)
          reversed_digits = int_digits.reverse
          reversed_digits.each_with_index do |digit, index|
            break unless carry.positive?

            next_digit = digit.next
            next_value = DIGIT_VALUE[next_digit]
            if next_value.nil? || next_value > threshold
              reversed_digits[index] = "0"
              next
            end

            reversed_digits[index] = next_digit
            carry = 0
          end

          [reversed_digits.reverse.join, carry]
        end

        def round_digit(digit, threshold)
          next_digit = digit.next
          next_value = DIGIT_VALUE[next_digit]
          return ["0", 1] if next_value.nil? || next_value > threshold

          carry = DIGIT_VALUE[digit] >= threshold ? 1 : 0
          [next_digit, carry]
        end

        def change_base(number)
          # Represent the fractional part exactly as a rational number to avoid
          # binary floating-point rounding errors when converting bases.
          fraction = Rational(number.to_i, 10**number.length)

          result = []
          digits = @precision || number.length

          digits.times do
            fraction *= base
            digit = fraction.to_i
            result << HEX_ALPHANUMERIC[digit]
            fraction -= digit
          end

          result.join
        end

        def raw_integer
          @result[0].delete(@int_group)
        end

        def base_default?
          base == DEFAULT_BASE
        end
      end
    end
  end
end
