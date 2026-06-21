# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Transforms fraction digits on Parts before localized rendering.
      class Fraction < Base
        attr_reader :decimal, :precision, :separator, :group

        DEFAULT_PRECISION = FormatOptions::DEFAULT_FRACTION_PRECISION
        DEFAULT_STRINGS = { empty: "", zero: "0", dot: "." }.freeze

        def initialize(options)
          super
          @group = self.options.fraction_group_digits
          @decimal = self.options.decimal
          @separator = self.options.fraction_group
          @precision = self.options.precision || DEFAULT_PRECISION
          @digit_count = self.options.digit_count
        end

        # Keep fraction preparation on structured parts; localized rendering and
        # grouping happen later at the PartsRenderer boundary.
        def apply_parts(parts, precision: self.precision)
          precision = precision.to_i
          return parts.with_digits(fraction_digits: DEFAULT_STRINGS[:empty]) unless precision.positive?

          @integer_digits = parts.integer_digits

          fraction = parts.fraction_digits
          if !base_default? && fraction.match?(/[1-9]/)
            fraction = change_base(fraction,
                                   precision)
          end
          number = if @digit_count.positive?
                     digit_count_format(fraction)
                   else
                     format(fraction, precision)
                   end

          parts.with_digits(
            integer_digits: integer_digits,
            fraction_digits: number.to_s,
          )
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

        # The digit_count option is a total visible-digit budget, so fraction
        # rounding can carry back into the integer digits.
        def digit_count_format(fraction)
          integer = integer_digits + DEFAULT_STRINGS[:dot] + fraction
          int_length = integer.length.pred # integer length; excluding the decimal point
          if int_length > @digit_count
            # When digit_count is within the integer length, omit the fraction
            # and let the integer carry handle rounding.
            if @digit_count <= integer_digits.length
              round_integer([], 1) if digit_sequence.round_up?(fraction[0])
              return DEFAULT_STRINGS[:empty]
            end
            round_base_string(fraction)
          elsif int_length < @digit_count
            fraction + (DEFAULT_STRINGS[:zero] * (@digit_count - int_length))
          else
            fraction
          end
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
            integer_digits.chars.reverse,
            carry: carry,
          )
          incremented = incremented.reverse.join
          new_integer = [incremented]
          if carry.positive?
            fraction_digits_reversed.pop
            new_integer.insert(0, "1")
          end
          @integer_digits = new_integer.join
        end

        def change_base(number, precision = self.precision)
          # Keep the decimal fraction exact while converting to the target base.
          fraction = Rational(number.to_i, 10**number.length)

          base_result = []

          precision.times do
            fraction *= base
            digit = fraction.to_i
            alpha_digit = HEX_ALPHANUMERIC[digit]
            base_result << alpha_digit
            fraction -= digit # Remove integer part, keep only fractional part
          end

          base_result.join
        end

        def integer_digits
          @integer_digits
        end

        def frac_digit_count
          @digit_count - integer_digits.length
        end
      end
    end
  end
end
