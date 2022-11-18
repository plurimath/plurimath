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
        symbol = Asciimath::Constants::SYMBOLS.invert[value.strip.to_sym].to_s
        symbol.empty? ? value : symbol
      end

      def to_mathml_without_math_tag
        unicode_symbols = Mathml::Constants::UNICODE_SYMBOLS.invert
        if unicode_symbols[value]
          Utility.ox_element("mo") << unicode_symbols[value].to_s
        else
          Utility.ox_element("mi") << value
        end
      end

      def to_latex
        symbols = Latex::Constants::SYMBOLS.invert
        symbols.key?(value) ? "\\#{symbols[value]}" : value
      end

      def to_html
        value
      end

      def to_omml_without_math_tag
        value
      end

      def class_name
        self.class.name.split("::").last.downcase
      end
    end
  end
end
