# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Parts
        attr_reader :base, :fraction_digits, :integer_digits, :sign, :source

        def initialize(
          sign:,
          base:,
          integer_digits:,
          fraction_digits:,
          source:
        )
          @sign = sign
          @base = base
          @integer_digits = normalize_integer(integer_digits)
          @fraction_digits = fraction_digits.to_s
          @source = source
        end

        def fractional?
          !fraction_digits.empty?
        end

        def integer_zero?
          integer_digits == "0"
        end

        def negative?
          sign.negative?
        end

        def significant_digit_count
          digits.sub(/\A0+/, "").length
        end

        def with_digits(
          integer_digits: self.integer_digits,
          fraction_digits: self.fraction_digits
        )
          self.class.new(
            sign: sign,
            base: base,
            integer_digits: integer_digits,
            fraction_digits: fraction_digits,
            source: source,
          )
        end

        def to_s
          number = fractional? ? "#{integer_digits}.#{fraction_digits}" : integer_digits
          negative? ? "-#{number}" : number
        end

        private

        def digits
          "#{integer_digits}#{fraction_digits}"
        end

        def normalize_integer(value)
          normalized = value.to_s.sub(/\A0+(?=.)/, "")
          normalized.empty? ? "0" : normalized
        end
      end
    end
  end
end
