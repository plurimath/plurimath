# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Fraction < Base
        attr_reader :format, :decimal, :precision, :separator, :group

        def initialize(token, symbols = {})
          @format  = token ? token.to_s("F").split('.').pop : ''
          @decimal = symbols[:decimal] || '.'
          @separator = symbols[:fraction_group].to_s
          @group = symbols[:fraction_group_digits]
          @digit_count = symbols[:digit_count] || nil
          @precision = @format.length
        end

        def apply(fraction, options = {}, int = "")
          precision = options[:precision] || self.precision
          return "" unless precision > 0

          number = interpolate(format(options), fraction, :left)
          number = digit_count_format(int, fraction, number) if @digit_count
          formatted_number = change_format(number) if number
          formatted_number ? decimal + formatted_number : ""
        end

        def format(options)
          precision = options[:precision] || self.precision
          precision ? '0' * precision : @format
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

        def digit_count_format(int, fraction, number)
          integer = int + "." + fraction
          float = BigDecimal(integer)
          int_length = integer.length - 1
          @digit_count ||= int_length
          if int_length > @digit_count
            number_string = float.round(@digit_count - int.length)
            numeric_digits(number_string) if @digit_count > int.length
          elsif int_length < @digit_count
            number + "0" * (update_digit_count(number) - int_length)
          else
            number
          end
        end

        def numeric_digits(num_str)
          float = num_str.to_s("F")
          return float.split(".").last if float.length == @digit_count + 1
          return unless @digit_count + 1 > float.length

          float.split(".")[0] + ("0" * (@digit_count - float.length + 1))
        end

        def update_digit_count(number)
          return @digit_count unless all_zeros?(number) == @precision

          @digit_count - @precision + 1
        end

        def all_zeros?(number)
          return unless number.split('').all? { |digit| digit == "0" }

          number.length
        end
      end
    end
  end
end
