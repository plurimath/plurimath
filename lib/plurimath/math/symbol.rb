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
        if Asciimath::Constants::SYMBOLS[value.to_sym].nil?
          value
        else
          Asciimath::Constants::SYMBOLS[value.to_sym].to_s
        end
      end

      def to_mathml_without_math_tag
        "<mo>#{mathml_symbol_value}</mo>"
      end

      def mathml_symbol_value
        Mathml::Constants::UNICODE_SYMBOLS.invert[value] || value
      end

      def to_latex
        symbols = Latex::Constants::SYMBOLS
        symbols.invert.key?(value) ? "\\#{symbols.invert[value]}" : value
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
