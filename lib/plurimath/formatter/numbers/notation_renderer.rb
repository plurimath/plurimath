# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class NotationRenderer
        SUPPORTED_NOTATIONS = %i[e scientific engineering].freeze

        def initialize(options)
          @options = FormatOptions.coerce(options)
          @precision = @options.precision || 0
        end

        def render(number_string, notation)
          case notation.to_sym
          when :e
            render_e(number_string)
          when :scientific
            render_scientific(number_string)
          when :engineering
            render_engineering(number_string)
          end
        end

        def self.supported?(notation)
          SUPPORTED_NOTATIONS.include?(notation&.to_sym)
        end

        private

        attr_reader :options
        attr_accessor :precision

        def render_e(number_string)
          localized_notation_parts(number_string).join(options.exponent_separator.to_s)
        end

        def render_scientific(number_string)
          localized_notation_parts(number_string).join(" #{options.times} 10^")
        end

        def render_engineering(number_string)
          self.precision = number_string.length - 1 unless precision.positive?

          parts = notation_parts(number_string)
          move_decimal_for_engineering(parts, parts.last.to_i % 3)
          parts[0] = localize_number(parts[0])
          parts.join(" #{options.times} 10^")
        end

        def localize_number(number_string)
          Formatter::NumberFormatter.new(
            BigDecimal(number_string),
            options,
          ).format(
            precision: precision,
          )
        end

        def localized_notation_parts(number_string)
          parts = notation_parts(number_string)
          parts[0] = localize_number(parts[0])
          parts << "0" if parts.length == 1
          parts
        end

        def notation_parts(number_string)
          decimal = BigDecimal(number_string)
          return [number_string, 0] if decimal.zero?

          parts = decimal.to_s("e").split("e")
          parts[1] = exponent_value(parts[1])
          coefficient = parts[0]
          coefficient = coefficient.gsub(/0\.(\d)/, '\1.')
          coefficient = coefficient.sub(".", "") if coefficient.start_with?(".")
          parts[0] = coefficient.end_with?(".") ? coefficient[0..-2] : coefficient
          parts
        end

        def exponent_value(number_string)
          exponent_number = BigDecimal(number_string) - 1
          return exponent_number.to_i if exponent_number.negative?
          return exponent_number.to_i if options.exponent_sign.to_s != "plus"

          "+#{exponent_number.to_i}"
        end

        def move_decimal_for_engineering(parts, index)
          return if index.zero?

          parts.first.delete!(".")
          parts.first.insert(index + 1, ".") unless parts.first[index + 2].nil?
          exponent = parts[-1]
          parts[-1] =
            "#{'+' if exponent.to_s.start_with?('+')}#{exponent.to_i - index}"
        end
      end
    end
  end
end
