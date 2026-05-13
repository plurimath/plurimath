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

        def initialize(value)
          @raw = value.to_s
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
          precision = integer_digits.length + fraction_digits.length - 1
          precision += 1 if sign.negative?
          [precision, 0].max
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
