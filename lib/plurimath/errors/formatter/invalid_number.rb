# frozen_string_literal: true

module Plurimath
  module Formatter
    class InvalidNumber < Plurimath::Error
      def initialize(value)
        @value = value
        super(message)
      end

      def message
        <<~MESSAGE
          [plurimath] Invalid number #{@value.inspect} for number formatting.
          [plurimath] Expected a numeric string such as "1234", "-12.34", or "1.2e5".
        MESSAGE
      end
    end
  end
end
