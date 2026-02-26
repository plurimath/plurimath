# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Fraction
        attr_reader :decimal, :precision, :separator, :group, :base

        DEFAULT_BASE = 10
        DEFAULT_PRECISION = 3
        DEFAULT_STRINGS = {
          hex_alphanumeric: %w[0 1 2 3 4 5 6 7 8 9 a b c d e f],
          empty: "",
          zero: "0",
          dot: ".",
          f: "F",
        }.freeze
        DIGIT_VALUE = DEFAULT_STRINGS[:hex_alphanumeric].each_with_index.to_h

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
          @int = result.first
          return DEFAULT_STRINGS[:empty] unless precision > 0

          fraction = convert_to_base(fraction) if fraction.match?(/[1-9]/)

          number = if @digit_count
                     digit_count_format(fraction)
                   else
                     format(fraction, precision)
                   end
          formatted_number = format_groups(number) if number
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
          return float.split(DEFAULT_STRINGS[:dot]).last if float.length == @digit_count + 1
          return unless @digit_count + 1 > float.length

          float.split(DEFAULT_STRINGS[:dot])[0] + (DEFAULT_STRINGS[:zero] * (@digit_count - float.length + 1))
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
          case @base.to_i
          when *NumberFormatter::DEFAULT_BASE_PREFIXES.except(10).keys
            round_base_string(fraction, round_value)
          else
            bigdecimal = BigDecimal(integer).round(round_value)
            bigdecimal = bigdecimal.to_s(DEFAULT_STRINGS[:f]) if bigdecimal.is_a?(BigDecimal)
            bigdecimal
          end
        end

        def round_base_string(fraction, keep)
          # Value of the first discarded digit
          return DEFAULT_STRINGS[:empty] unless keep.positive?
          return fraction if fraction.length < keep

          threshold = @base.div(2) # 1, 4, 5, 8 for bases 2, 8, 10, 16
          # Extract the remaining including the one that is going to be rounded-up.
          digits = fraction[0..keep].split("")
          # Check the number if it should be discarded or round-up the rest of the numbers.
          discard_char = digits.pop

          # return if the number is required to be discarded only.
          return digits.join if DIGIT_VALUE[discard_char] < threshold

          # rounding-up the rest of the numbers
          carry = 1
          result = []
          digits.reverse_each.with_index do |digit, index|
            next result << digit unless carry.positive?

            numeric_value = DIGIT_VALUE[digit]
            if DIGIT_VALUE[digit.next].nil?
              # TODO: validate and update the next digit
            else
              result << digit.next
            end

            carry = 0 unless numeric_value >= threshold
          end
          round_integer if carry.positive?

          result.join
        end

        def round_integer
          # update the integer of the fraction's first digit (alphanumeric value) after the decimal point is greater than the base's threshold.
          # @int.chars.each do ||
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
            result << DEFAULT_STRINGS[:hex_alphanumeric][digit]
            fraction -= digit
          end

          result.join
        end

        def raw_integer
          @int.delete(@int_group)
        end

        def base_default?
          base == DEFAULT_BASE
        end
      end
    end
  end
end
