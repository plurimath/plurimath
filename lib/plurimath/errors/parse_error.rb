# frozen_string_literal: true

module Plurimath
  module Math
    class ParseError < TypeError
      def initialize(text, type)
        @text = text
        @type = type.to_sym
      end

      def to_s
        @type == :unitsml_parse_error ? unitsml_message : message
      end

      def message
        <<~MESSAGE
          [plurimath] Error: Failed to parse the following formula with type `#{@type}`.
          [plurimath] Please first manually validate the formula.
          #{generic_part}
          ---- FORMULA BEGIN ----
          #{@text}
          ---- FORMULA END ----
        MESSAGE
      end

      def unitsml_message
        <<~MESSAGE
          [plurimath] Invalid formula `#{@text}`.
          [plurimath] The use of a variable as an exponent is not valid.
          #{generic_part}
        MESSAGE
      end

      def generic_part
        <<~MESSAGE.rstrip
          [plurimath] If this is a bug, please report the formula at our issue tracker at:
          [plurimath] https://github.com/plurimath/plurimath/issues
        MESSAGE
      end
    end
  end
end
