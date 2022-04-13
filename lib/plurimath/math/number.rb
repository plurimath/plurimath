# frozen_string_literal: true

module Plurimath
  module Math
    class Number
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def to_asciimath
        value
      end

      def ==(object)
        object.value == value
      end
    end
  end
end
