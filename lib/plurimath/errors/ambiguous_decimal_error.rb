# frozen_string_literal: true

module Plurimath
  module Math
    # An AsciiMath uncertainty call whose comma could be a decimal comma under
    # the active locale. A ParseError, so Plurimath::Math.parse passes it on
    # with its message intact.
    class AmbiguousDecimalError < ParseError
      def initialize(detail)
        @detail = detail
        super(detail, :asciimath)
      end

      def parsing_message
        "[plurimath] #{@detail}"
      end
    end
  end
end
