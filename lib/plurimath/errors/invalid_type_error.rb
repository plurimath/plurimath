# frozen_string_literal: true

module Plurimath
  module Math
    class InvalidTypeError < StandardError
      def initialize(type = nil)
        super(type ? formula_message : parse_message)
      end

      def parse_message
        "`type` must be one of: `#{Math::VALID_TYPES.keys.join('`, `')}`"
      end

      def formula_message
        "Invalid type provided: #{@type}. Must be one of #{Formula::MATH_ZONE_TYPES.join(', ')}."
      end
    end
  end
end
