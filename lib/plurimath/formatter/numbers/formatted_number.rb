# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Structured result of number formatting. Carries sign, digit parts,
      # decimal separator, and base notation as separate semantic elements
      # so output renderers (MathML, LaTeX, etc.) can produce structured
      # representations instead of flat strings.
      class FormattedNumber
        attr_reader :sign, :integer_part, :fraction_part,
                    :decimal_separator, :base_notation, :number_sign

        def initialize(
          sign:,
          integer_part:,
          fraction_part:,
          decimal_separator:,
          base_notation:,
          number_sign: nil
        )
          @sign = sign
          @integer_part = integer_part
          @fraction_part = fraction_part
          @decimal_separator = decimal_separator
          @base_notation = base_notation
          @number_sign = number_sign
        end

        def negative?
          sign == -1
        end

        def fractional?
          !fraction_part.empty?
        end

        def base_notation?
          !base_notation.default?
        end

        # The sign as a rendering prefix: "-" for negative, "+" when
        # number_sign is :plus, nil otherwise. Output renderers use this
        # to produce format-specific sign elements.
        def sign_text
          if negative?
            "-"
          elsif number_sign == :plus
            "+"
          end
        end

        def to_s
          digits = formatted_digits
          digits = base_notation.wrap(digits) unless base_notation.default?
          "#{sign_text}#{digits}"
        end

        def to_str
          to_s
        end

        # Digits with decimal separator and optional hex capitalization,
        # but without sign, prefix, or postfix. Used by structured renderers
        # that handle sign and base notation as separate elements.
        def digits_string
          formatted_digits
        end

        private

        def formatted_digits
          digits = assembled_digits
          base_notation.upcase_hex? ? upcase_hex(digits) : digits
        end

        def assembled_digits
          fractional? ? "#{integer_part}#{decimal_separator}#{fraction_part}" : integer_part
        end

        def upcase_hex(string)
          string.tr(Base::HEX_DIGITS, Base::HEX_DIGITS.upcase)
        end
      end
    end
  end
end
