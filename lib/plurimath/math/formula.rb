# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      attr_accessor :value

      def initialize(value = [])
        @value = value.is_a?(Array) ? value : [value]
      end

      def ==(object)
        object.value == value
      end

      def to_asciimath
        value.map(&:to_asciimath).join("")
      end
    end
  end
end
