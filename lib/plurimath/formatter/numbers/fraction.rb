# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Fraction < TwitterCldr::Formatters::Numbers::Fraction
        attr_reader :format, :decimal, :precision, :separator, :group

        def initialize(token, symbols = {})
          @format  = token ? token.value.split('.').pop : ''
          @decimal = symbols[:decimal] || '.'
          @separator = symbols[:fraction_group].to_s
          @group = symbols[:fraction_group_digits]
          @digit_count = symbols[:digit_count] || nil
          @precision = @format.length
        end

        def apply(fraction, options = {}, int = "")
          precision = options[:precision] || self.precision
          return "" unless precision > 0

          require "debug"; binding.b
          number = interpolate(format(options), fraction, :left)
          number = digit_count_format(int, fraction, number) if @digit_count
          formatted_number = change_format(precision, number) if number
          formatted_number ? decimal + formatted_number : ""
        end

        def format(options)
          precision = options[:precision] || self.precision
          precision ? '0' * precision : @format
        end

        protected

        def change_format(precision, string)
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
            number_string = float.round(@digit_count - int.length).to_s("F")
            @digit_count > int.length ? number_string.to_s.split(".").last : nil
          elsif int_length < @digit_count
            number + "0" * (@digit_count - int_length)
          else
            number
          end
        end
      end
    end
  end
end
