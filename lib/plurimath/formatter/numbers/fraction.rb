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

        def initialize(symbols = {})
          @base        = symbols[:base] || DEFAULT_BASE
          @group       = symbols[:fraction_group_digits]
          @decimal     = symbols.fetch(:decimal, DEFAULT_STRINGS[:dot])
          @separator   = symbols[:fraction_group].to_s
          @precision   = symbols.fetch(:precision, DEFAULT_PRECISION)
          @digit_count = symbols[:digit_count]
        end

        def apply(fraction, options = {}, int = DEFAULT_STRINGS[:empty])
          precision = options[:precision] || @precision
          return DEFAULT_STRINGS[:empty] unless precision > 0

          fraction = convert_to_base(fraction) if fraction.match?(/[1-9]/)

          number = if @digit_count
                     digit_count_format(int, fraction)
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

        def digit_count_format(int, fraction)
          integer = int + DEFAULT_STRINGS[:dot] + fraction
          int_length = integer.length - 1 # integer length; excluding the decimal point
          @digit_count ||= int_length
          if int_length > @digit_count
            number_string = BigDecimal(integer).round(@digit_count - int.length)
            numeric_digits(number_string) if @digit_count > int.length
          elsif int_length < @digit_count
            fraction + (DEFAULT_STRINGS[:zero] * (update_digit_count(fraction) - int_length))
          else
            fraction
          end
        end

        def numeric_digits(num_str)
          float = num_str.to_s(DEFAULT_STRINGS[:f])
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

        def change_base(number)
          n = "0.#{number}".to_f
          result = []
          digits = @precision || number.length

          digits.times do
            n *= base
            digit = n.to_i
            result << DEFAULT_STRINGS[:hex_alphanumeric][digit]
            n -= digit
            break if n.zero?
          end

          result.join
        end

        def base_default?
          base == DEFAULT_BASE
        end
      end
    end
  end
end
