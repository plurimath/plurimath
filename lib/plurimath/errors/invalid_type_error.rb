# frozen_string_literal: true

module Plurimath
  module Math
    class InvalidTypeError < TypeError
      def initialize(type = nil)
        super(type ? formula_message(type) : parse_message)
      end

      def parse_message
        "`type` must be one of: `#{Math::VALID_TYPES.keys.join('`, `')}`"
      end

      def formula_message(type)
        "Invalid type provided: #{type}. Must be one of #{Formula::MATH_ZONE_TYPES.join(', ')}."
      end
    end
  end
end
