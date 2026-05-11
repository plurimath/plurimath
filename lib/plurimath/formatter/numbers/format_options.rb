# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class FormatOptions
        DEFAULT_EXPONENT_SEPARATOR = :e
        DEFAULT_TIMES = "\u{d7}"

        attr_reader :exponent_separator, :exponent_sign, :notation,
                    :precision, :times

        def initialize(number_string, format:, precision:, precision_resolver:)
          @format = format
          @notation = symbol_option(:notation)
          @exponent_separator = symbol_option(:e) || DEFAULT_EXPONENT_SEPARATOR
          @times = symbol_option(:times) || DEFAULT_TIMES
          @precision = precision_resolver.resolve(
            number_string,
            precision: precision,
            format: format,
            notation: notation,
          )
          @exponent_sign = symbol_option(:exponent_sign)
        end

        private

        attr_reader :format

        def symbol_option(key)
          format[key]&.to_sym
        end
      end
    end
  end
end
