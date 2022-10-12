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
        symbol = Asciimath::Constants::SYMBOLS.invert[value.to_sym].to_s
        symbol.empty? ? value : symbol
      end

      def to_mathml_without_math_tag
        unicode_symbols = Mathml::Constants::UNICODE_SYMBOLS.invert
        if unicode_symbols[value]
          "<mo>#{unicode_symbols[value]}</mo>"
        else
          "<mi>#{value}</mi>"
        end
      end

      def to_latex
        symbols = Latex::Constants::SYMBOLS.invert
        symbols.key?(value) ? "\\#{symbols[value]}" : value
      end

      def to_html
        value
      end

      def class_name
        self.class.name.split("::").last.downcase
      end
    end
  end
end
