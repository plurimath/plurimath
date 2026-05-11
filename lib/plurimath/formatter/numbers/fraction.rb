# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Fraction < Base
        attr_reader :decimal, :precision, :separator, :group

        DEFAULT_PRECISION = 3
        DEFAULT_STRINGS = { empty: "", zero: "0", dot: ".", f: "F" }.freeze

        def initialize(symbols = {})
          super
          @group       = symbols[:fraction_group_digits]
          @decimal     = symbols.fetch(:decimal, DEFAULT_STRINGS[:dot])
          @int_group   = symbols[:group]
          @separator   = symbols[:fraction_group].to_s
          @precision   = symbols.fetch(:precision, DEFAULT_PRECISION)
          @digit_count = symbols[:digit_count].to_i
        end

        def apply(fraction, result, integer_formatter)
          precision = symbols[:precision] || @precision
          @result = result
          @integer_formatter = integer_formatter
          return DEFAULT_STRINGS[:empty] unless precision.positive?

          fraction = change_base(fraction) if !base_default? && fraction.match?(/[1-9]/)

          number = if @digit_count.positive?
                     digit_count_format(fraction)
                   else
                     format(fraction, precision)
                   end
          formatted_number = format_groups(number) if number && !number.empty?
          formatted_number ? decimal + formatted_number : DEFAULT_STRINGS[:empty]
        end

        def raw_digits(fraction, integer)
          precision = symbols[:precision] || @precision
          return [integer, DEFAULT_STRINGS[:empty]] unless precision.positive?

          @result = [integer]
          @integer_formatter = Numbers::RawIntegerFormatter.new

          fraction = change_base(fraction) if !base_default? && fraction.match?(/[1-9]/)
          number = if @digit_count.positive?
                     digit_count_format(fraction)
                   else
                     format(fraction, precision)
                   end

          [raw_integer, number.to_s]
        end

        def format(number, precision)
          return number if precision <= number.length

          number + (DEFAULT_STRINGS[:zero] * (precision - number.length))
        end

        def format_groups(string, length = group)
          string = capitalize_hex_digits(string)
          length = string.length if group.to_i.zero?

          change_format(string, length)
        end

        protected

        def change_format(string, length)
          tokens = []
          until string.empty?
            tokens << string.slice(0, length)
            string = string[tokens.last.size..]
          end
          tokens.compact.join(separator)
        end

        def digit_count_format(fraction)
          integer = raw_integer + DEFAULT_STRINGS[:dot] + fraction
          int_length = integer.length.pred # integer length; excluding the decimal point
          if int_length > @digit_count
            # When digit_count is less than or equal to the integer length,
            # omit the fractional part entirely and handle rounding in the integer
            if @digit_count <= raw_integer.length
              round_integer([], 1) if digit_sequence.round_up?(fraction[0])
              return DEFAULT_STRINGS[:empty]
            end
            round_base_string(fraction)
          elsif int_length < @digit_count
            fraction + (DEFAULT_STRINGS[:zero] * (update_digit_count(fraction) - int_length))
          else
            fraction
          end
        end

        def update_digit_count(number)
          return @digit_count unless zeros_count_in(number) == @precision

          @digit_count - @precision + 1
        end

        def zeros_count_in(number)
          return unless number.chars.all?(DEFAULT_STRINGS[:zero])

          number.length
        end

        def round_base_string(fraction)
          digits = fraction[0..frac_digit_count].chars
          discard_char = digits.pop
          return DEFAULT_STRINGS[:empty] unless discard_char

          return digits.join unless digit_sequence.round_up?(discard_char)

          rounded_reversed, carry = digit_sequence.increment_reversed(digits.reverse)
          round_integer(rounded_reversed, carry) if carry.positive?
          rounded_reversed.reverse.join unless rounded_reversed.empty?
        end

        def round_integer(fraction_digits_reversed, carry = 1)
          incremented, carry = digit_sequence.increment_reversed(
            raw_integer.chars.reverse,
            carry: carry,
            skip: [decimal, @int_group],
          )
          incremented = incremented.reverse.join
          new_integer = [incremented]
          if carry.positive?
            fraction_digits_reversed.pop
            new_integer.insert(0, "1")
          end
          @result[0] = @integer_formatter.format_groups(new_integer.join)
        end

        def change_base(number)
          # Convert fractional part from base 10 to target base using rational arithmetic
          # to avoid floating-point rounding errors.
          # Algorithm: repeatedly multiply fraction by base, extract integer part as next digit
          # Represent the fractional part exactly as a rational number to avoid
          # binary floating-point rounding errors when converting bases.
          # Note: The input `number` is always in decimal (base 10) format,
          # so we use 10 as the denominator base regardless of the target base.
          fraction = Rational(number.to_i, 10**number.length)

          base_result = []
          digits = @precision || number.length

          digits.times do
            fraction *= base
            digit = fraction.to_i
            alpha_digit = HEX_ALPHANUMERIC[digit]
            base_result << alpha_digit
            fraction -= digit # Remove integer part, keep only fractional part
          end

          base_result.join
        end

        def raw_integer
          @result[0].delete(@int_group.to_s)
        end

        def frac_digit_count
          @digit_count - raw_integer.length
        end
      end
    end
  end
end
