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

        def apply(fraction, options = {}, result, integer_formatter)
          precision = options[:precision] || @precision
          @result = result
          @integer_formatter = integer_formatter
          return DEFAULT_STRINGS[:empty] unless precision.positive?

          fraction = change_base(fraction) if fraction.match?(/[1-9]/)

          number = if @digit_count.positive?
                     digit_count_format(fraction)
                   else
                     format(fraction, precision)
                   end
          formatted_number = format_groups(number) if number && !number.empty?
          formatted_number ? decimal + formatted_number : DEFAULT_STRINGS[:empty]
        end

        def format(number, precision)
          return number if precision <= number.length

          number + (DEFAULT_STRINGS[:zero] * (precision - number.length))
        end

        def format_groups(string, length = group)
          length = string.length if group.to_i.zero?

          change_format(string, length)
        end

        protected

        def change_format(string, length)
          tokens = []
          until string.empty?
            tokens << string.slice(0, length)
            string = string[tokens.last.size..-1]
          end
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
          return unless number.chars.all?(DEFAULT_STRINGS[:zero])

          number.length
        end

        def round_base_string(fraction)
          # Extract the digits we need, plus one extra digit for rounding decision
          digits = fraction[0..frac_digit_count].chars
          discard_char = digits.pop
          return DEFAULT_STRINGS[:empty] unless discard_char
          # If the discarded digit is below the rounding threshold (< base/2), truncate
          return digits.join if DIGIT_VALUE[discard_char] < threshold

          # Perform carry propagation for rounding up
          carry = 1
          rounded_reversed = []
          digits.reverse_each do |digit|
            next rounded_reversed << digit unless carry.positive?

            # If current digit is at max value for this base (e.g., 'f' for base 16),
            # set it to '0' and continue carrying
            rounded_reversed << if DIGIT_VALUE[digit] == base.pred
                                  DEFAULT_STRINGS[:zero]
                                else
                                  # Otherwise, increment this digit and stop carrying
                                  carry = 0
                                  next_mapping_char(digit)
                                end
          end

          # If we still have a carry after processing all fractional digits,
          # we need to round up the integer part
          round_integer(rounded_reversed, carry) if carry.positive?
          rounded_reversed.reverse.join unless rounded_reversed.empty?
        end

        def round_integer(fraction_digits_reversed, carry = 1)
          # Propagate carry into the integer part, updating the formatted result
          incremented, carry = increment_integer_digits(raw_integer.chars.reverse, carry)
          new_integer = [incremented]
          if carry.positive?
            # If carry propagates through all integer digits (e.g., 9+1=10 in base 10),
            # we need to prepend '1' and remove one fractional digit to maintain digit_count
            fraction_digits_reversed.pop
            new_integer.insert(0, "1")
          end
          # Update the result array with the new integer value
          @result[0] = @integer_formatter.format_groups(new_integer.join)
        end

        def increment_integer_digits(digits, carry)
          # Skip over separator characters while propagating carry through integer digits
          str_chars = [decimal, @int_group]
          digits.each_with_index do |digit, index|
            next if str_chars.include?(digit)

            if DIGIT_VALUE[digit] == base.pred
              # Digit is at max value (e.g., 'f' for base 16), set to '0' and continue carry
              digits[index] = DEFAULT_STRINGS[:zero]
            else
              # Increment this digit and stop carrying
              digits[index] = next_mapping_char(digit)
              break carry = 0
            end
          end

          [digits.reverse.join, carry]
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
            fraction -= digit  # Remove integer part, keep only fractional part
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
