# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Fraction
        attr_reader :decimal, :precision, :separator, :group

        def initialize(symbols = {})
          @precision = 3
          @decimal = symbols[:decimal] || '.'
          @separator = symbols[:fraction_group].to_s
          @group = symbols[:fraction_group_digits]
          @digit_count = symbols[:digit_count] || nil
        end

        def apply(fraction, options = {}, int = "")
          precision = options[:precision] || @precision
          return "" unless precision > 0

          number = if @digit_count
                     digit_count_format(int, fraction)
                   else
                     format(fraction, precision)
                   end

          formatted_number = change_format(number) if number
          formatted_number ? decimal + formatted_number : ""
        end

        def format(number, precision)
          number + "0" * (precision - number.length)
        end

        def format_groups(string)
          change_format(string)
        end

        protected

        def change_format(string)
          tokens = []
          tokens << string&.slice!(0, (group || string.length)) until string&.empty?
          tokens.compact.join(separator)
        end

        def digit_count_format(int, fraction)
          integer = int + "." + fraction
          int_length = integer.length - 1 # integer length; excluding the decimal point
          @digit_count ||= int_length
          if int_length > @digit_count
            number_string = BigDecimal(integer).round(@digit_count - int.length)
            numeric_digits(number_string) if @digit_count > int.length
          elsif int_length < @digit_count
            fraction + ("0" * (update_digit_count(fraction) - int_length))
          else
            fraction
          end
        end

        def numeric_digits(num_str)
          float = num_str.to_s("F")
          return float.split(".").last if float.length == @digit_count + 1
          return unless @digit_count + 1 > float.length

          float.split(".")[0] + ("0" * (@digit_count - float.length + 1))
        end

        def update_digit_count(number)
          return @digit_count unless zeros_count_in(number) == @precision

          @digit_count - @precision + 1
        end

        def zeros_count_in(number)
          return unless number.split('').all? { |digit| digit == "0" }

          number.length
        end
      end
    end
  end
end
