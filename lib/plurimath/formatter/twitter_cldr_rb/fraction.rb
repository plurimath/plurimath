# frozen_string_literal: true

module TwitterCldr
  module Formatters
    module Numbers
      class Fraction
        attr_reader :format, :decimal, :precision, :separator, :group

        def initialize(token, symbols = {})
          @format  = token ? token.value.split('.').pop : ''
          @decimal = symbols[:decimal] || '.'
          @separator = symbols[:fraction_group] || " "
          @group = symbols[:fraction_group_digits] || 3
          @digit_count = symbols[:digit_count] || nil
          @precision = @format.length
        end

        def apply(fraction, options = {}, int = "")
          precision = options[:precision] || self.precision
          if precision > 0
            number = interpolate(format(options), fraction, :left)
            number = digit_count_format(int, fraction, number) if @digit_count
            decimal + change_format(precision, number)
          else
            ''
          end
        end

        def format(options)
          precision = options[:precision] || self.precision
          precision ? '0' * precision : @format
        end

        protected

        def change_format(precision, string)
          tokens = []
          tokens << string&.slice!(0, group) until string&.empty?
          tokens.compact.join(separator)
        end

        def digit_count_format(int, fraction, number)
          integer = (int + "." + fraction)
          float = integer.to_f
          int_length = integer.length - 1
          @digit_count ||= int_length
          if int_length > @digit_count
            float.round(@digit_count - int.length).to_s.split(".").last
          elsif int_length < @digit_count
            number += "0" * (@digit_count - int_length)
          end
        end
      end
    end
  end
end

