# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class FormatOptions
        DEFAULT_EXPONENT_SEPARATOR = :e
        DEFAULT_DECIMAL = "."
        DEFAULT_FRACTION_PRECISION = 3
        DEFAULT_GROUP = ","
        DEFAULT_GROUP_DIGITS = 3
        DEFAULT_TIMES = "\u{d7}"

        attr_reader :exponent_separator, :exponent_sign, :notation, :symbols,
                    :times
        attr_accessor :precision

        def self.coerce(options)
          return options if options.is_a?(self)

          new(symbols: options || {})
        end

        def initialize(
          number_string = nil,
          symbols: {},
          format: nil,
          precision: nil,
          precision_resolver: nil
        )
          @symbols = symbols.dup
          @format = format || @symbols
          @notation = symbol_option(:notation)
          @exponent_separator = symbol_option(:e) || DEFAULT_EXPONENT_SEPARATOR
          @times = symbol_option(:times) || DEFAULT_TIMES
          @precision = resolve_precision(number_string, precision, precision_resolver)
          @exponent_sign = symbol_option(:exponent_sign)
        end

        def base
          symbols[:base] || Base::DEFAULT_BASE
        end

        def base_prefix
          symbols[:base_prefix].to_s
        end

        def base_prefix?
          symbols.key?(:base_prefix)
        end

        def base_postfix
          symbols[:base_postfix]
        end

        def base_postfix?
          symbols.key?(:base_postfix)
        end

        def decimal
          symbols.fetch(:decimal, DEFAULT_DECIMAL)
        end

        def digit_count
          symbols[:digit_count].to_i
        end

        def fraction_group
          symbols[:fraction_group].to_s
        end

        def fraction_group_digits
          symbols[:fraction_group_digits]
        end

        def group
          symbols[:group] || DEFAULT_GROUP
        end

        def group_digits
          symbols[:group_digits] || DEFAULT_GROUP_DIGITS
        end

        def hex_capital
          symbols[:hex_capital]
        end

        def number_sign
          symbols[:number_sign]
        end

        def significant
          symbols[:significant].to_i
        end

        def to_h
          symbols.dup
        end

        private

        attr_reader :format

        def resolve_precision(number_string, precision, precision_resolver)
          return precision || symbols[:precision] unless precision_resolver

          precision_resolver.resolve(
            number_string,
            precision: precision,
            format: format,
            notation: notation,
          )
        end

        def symbol_option(key)
          format[key]&.to_sym
        end
      end
    end
  end
end
