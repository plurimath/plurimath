# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Per-render view of merged formatter symbols and resolved precision.
      class FormatOptions
        DEFAULT_EXPONENT_SEPARATOR = :e
        DEFAULT_DECIMAL = "."
        DEFAULT_FRACTION_PRECISION = 3
        DEFAULT_GROUP = ","
        DEFAULT_GROUP_DIGITS = 3
        DEFAULT_PADDING = "0"
        DEFAULT_TIMES = "\u{d7}"

        attr_reader :exponent_separator, :exponent_sign, :notation, :symbols,
                    :precision, :times

        def initialize(
          source = nil,
          symbols: {},
          precision: nil,
          precision_resolver: nil
        )
          @symbols = symbols.dup
          @notation = symbol_option(:notation)
          @exponent_separator = symbol_option(:e) || DEFAULT_EXPONENT_SEPARATOR
          @times = symbol_option(:times) || DEFAULT_TIMES
          @precision = resolve_precision(source, precision, precision_resolver)
          @exponent_sign = symbol_option(:exponent_sign)
          validate_padding_options!
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

        def padding
          value = symbols.fetch(:padding, DEFAULT_PADDING).to_s
          value.empty? ? DEFAULT_PADDING : value[0]
        end

        def padding_digits
          symbols[:padding_digits].to_i
        end

        def padding_group_digits
          symbols[:padding_group_digits].to_i
        end

        def notation_supported?
          NotationRenderer.supported?(notation)
        end

        def significant
          symbols[:significant].to_i
        end

        def to_h
          symbols.dup
        end

        private

        def resolve_precision(source, precision, precision_resolver)
          effective_precision = precision || symbols[:precision]
          return effective_precision unless precision_resolver

          precision_resolver.resolve(
            source,
            precision: effective_precision,
            base: base,
            significant: significant,
            notation_supported: notation_supported?,
          )
        end

        def symbol_option(key)
          symbols[key]&.to_sym
        end

        def validate_padding_options!
          return unless padding_digits.positive? && padding_group_digits.positive?

          raise Plurimath::ConfigurationError.new(
            :mutually_exclusive_formatter_options,
            supported: %i[padding_digits padding_group_digits],
          )
        end
      end
    end
  end
end
