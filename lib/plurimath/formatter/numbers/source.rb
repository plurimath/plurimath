# frozen_string_literal: true

require "bigdecimal"

module Plurimath
  module Formatter
    module Numbers
      # Captures raw input, BigDecimal interpretation, and source digit metadata
      # before formatter transforms run.
      class Source
        attr_reader :decimal, :exponent, :exponent_text, :fraction_digits,
                    :integer_digits, :raw, :sign

        DEFAULT_INTEGER = "0"
        EMPTY_STRING = ""
        # Stricter than BigDecimal(), which tolerates underscores, surrounding
        # junk after partial parses, and Infinity/NaN spellings.
        NUMERIC_PATTERN = /\A[+-]?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?\z/

        def initialize(value)
          @raw = value.to_s
          validate_numeric!(value)
          @decimal = BigDecimal(raw)
          @sign = raw.start_with?("-") ? -1 : 1

          mantissa, @exponent_text = unsigned_value.split("e", 2)
          @exponent = exponent_text.to_i
          @integer_digits, @fraction_digits = split_mantissa(mantissa)
        end

        def fractional?
          fraction_digits.length > exponent
        end

        def decimal_precision
          decimal_digits.last.length
        end

        def notation_precision
          # A zero coefficient keeps the source's stated fraction width.
          return fraction_digits.length if decimal.zero?

          # The coefficient's fraction width is its significant-digit count
          # minus the single leading digit; the sign and leading zeros carry
          # no precision.
          [significant_digit_count - 1, 0].max
        end

        def significant_digit_count
          significant_digits.length
        end

        def target_base_integer_length(base)
          return decimal_parts_integer_length if base == Base::DEFAULT_BASE

          integer = decimal.abs.to_i
          return 0 if integer.zero?

          integer.to_s(base).length
        end

        def to_parts(base: nil, precision: nil)
          integer, fraction = decimal_digits
          fraction = apply_precision(fraction, precision)

          Parts.new(
            sign: sign,
            base: base || Base::DEFAULT_BASE,
            integer_digits: integer,
            fraction_digits: fraction,
          )
        end

        def trailing_fraction_zero_count
          return 0 if fraction_digits.empty?

          fraction_digits.length - fraction_digits.sub(/0+\z/, "").length
        end

        private

        def validate_numeric!(value)
          valid_type = value.is_a?(Numeric) || value.is_a?(String)
          return if valid_type && NUMERIC_PATTERN.match?(raw)

          raise Plurimath::Formatter::InvalidNumber, value
        end

        def decimal_parts_integer_length
          parts = to_parts
          return 0 if parts.integer_zero?

          parts.integer_digits.length
        end

        def apply_precision(fraction, precision)
          return fraction unless precision

          size = precision.to_i
          return EMPTY_STRING unless size.positive?

          fraction[0...size]
        end

        def decimal_digits
          digits = "#{integer_digits}#{fraction_digits}"
          decimal_index = integer_digits.length + exponent

          if decimal_index <= 0
            [DEFAULT_INTEGER, "#{'0' * decimal_index.abs}#{digits}"]
          elsif decimal_index >= digits.length
            ["#{digits}#{'0' * (decimal_index - digits.length)}", EMPTY_STRING]
          else
            [digits[0...decimal_index], digits[decimal_index..]]
          end
        end

        def significant_digits
          "#{integer_digits}#{fraction_digits}".sub(/\A0+/, "")
        end

        def split_mantissa(mantissa)
          integer, fraction = mantissa.split(".", 2)
          integer = DEFAULT_INTEGER if integer.to_s.empty?

          [integer, fraction.to_s]
        end

        def unsigned_value
          raw.downcase.sub(/\A[-+]/, "")
        end
      end
    end
  end
end
