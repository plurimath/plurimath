# frozen_string_literal: true

module Plurimath
  module Math
    class Symbol
      attr_accessor :value

      def initialize(sym)
        @value = sym
      end

      def ==(object)
        object.value == value
      end

      def to_asciimath
        value
      end

      def to_mathml_without_math_tag
        "<mo>#{mathml_symbol_value}</mo>"
      end

      def mathml_symbol_value
        Mathml::Constants::UNICODE_SYMBOLS.invert[value] || value
      end
    end
  end
end
