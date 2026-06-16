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
          value = symbols[:base]
          return Base::DEFAULT_BASE if value.nil?

          # Numeric String/Symbol forms are normalized; anything else is left
          # raw so BaseNotation reports it through UnsupportedBase.
          coerce_integer(value) { return value }
        end

        def base_prefix
          separator_option(:base_prefix).to_s
        end

        def base_prefix?
          symbols.key?(:base_prefix)
        end

        def base_postfix
          separator_option(:base_postfix)
        end

        def base_postfix?
          symbols.key?(:base_postfix)
        end

        def decimal
          # An explicitly passed nil renders without a separator; output
          # correctness is then the caller's responsibility.
          separator_option(:decimal, default: DEFAULT_DECIMAL)
        end

        def digit_count
          integer_option(:digit_count, default: 0)
        end

        def fraction_group
          separator_option(:fraction_group).to_s
        end

        def fraction_group_digits
          integer_option(:fraction_group_digits)
        end

        def group
          # Unlike decimal, an explicit nil group falls back to the default
          # separator (released 0.10.7 behavior); use "" to disable grouping.
          (separator_option(:group, default: DEFAULT_GROUP) || DEFAULT_GROUP).to_s
        end

        def group_digits
          integer_option(:group_digits, default: DEFAULT_GROUP_DIGITS)
        end

        def hex_capital
          # Attribute-parsing callers deliver the value as a Symbol or String
          # (:true, "numbers_only"), so it cannot be compared raw against
          # true/:numbers_only.
          case symbols[:hex_capital].to_s
          when "true" then true
          when "numbers_only" then :numbers_only
          end
        end

        def number_sign
          symbol_option(:number_sign)
        end

        def padding
          value = separator_option(:padding, default: DEFAULT_PADDING).to_s
          value.empty? ? DEFAULT_PADDING : value[0]
        end

        def padding_digits
          integer_option(:padding_digits, default: 0)
        end

        def padding_group_digits
          integer_option(:padding_group_digits, default: 0)
        end

        def notation_supported?
          NotationRenderer.supported?(notation)
        end

        # Whether precision came from the caller (kwarg or symbols) rather
        # than being inferred from the source by the resolver.
        def explicit_precision?
          @explicit_precision
        end

        def significant
          integer_option(:significant, default: 0)
        end

        def to_h
          symbols.dup
        end

        private

        def resolve_precision(source, precision, precision_resolver)
          # A nil check (not ||) so that explicit false reaches validation.
          effective_precision = precision.nil? ? symbols[:precision] : precision
          unless effective_precision.nil?
            value = effective_precision
            effective_precision = coerce_integer(value) do
              invalid_option!(:precision, value)
            end
            if effective_precision.negative?
              invalid_option!(:precision, value, expected: "a non-negative integer")
            end
          end
          @explicit_precision = !effective_precision.nil?
          return effective_precision unless precision_resolver

          precision_resolver.resolve(
            source,
            precision: effective_precision,
            base: base,
            significant: significant,
            digit_count: digit_count,
            notation_supported: notation_supported?,
          )
        end

        # Counts must be non-negative Integers; numeric String/Symbol forms are
        # normalized because attribute-parsing callers deliver those.
        def integer_option(key, default: nil)
          value = symbols[key]
          return default if value.nil?

          integer = coerce_integer(value) { invalid_option!(key, value) }
          invalid_option!(key, value, expected: "a non-negative integer") if integer.negative?

          integer
        end

        def coerce_integer(value)
          case value
          when ::Integer then value
          when true, false, Float then yield
          else
            begin
              Integer(value.to_s, 10)
            rescue ArgumentError, TypeError
              yield
            end
          end
        end

        # Separators are free-form strings; explicit nil disables the
        # separator, and Booleans are always a caller bug.
        def separator_option(key, default: nil)
          value = symbols.fetch(key, default)
          invalid_option!(key, value) if [true, false].include?(value)

          value
        end

        def symbol_option(key)
          value = symbols[key]
          return if value.nil?

          invalid_option!(key, value) if [true, false].include?(value)

          value.to_s.to_sym
        end

        def invalid_option!(key, value, expected: nil)
          raise Plurimath::ConfigurationError.new(
            :invalid_formatter_option,
            option: key,
            value: value,
            supported: expected,
          )
        end

        def validate_padding_options!
          return unless symbols.key?(:padding_digits) && symbols.key?(:padding_group_digits)

          raise Plurimath::ConfigurationError.new(
            :conflicting_formatter_options,
            supported: %i[padding_digits padding_group_digits],
          )
        end
      end
    end
  end
end
