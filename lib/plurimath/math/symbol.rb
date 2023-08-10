# frozen_string_literal: true

module Plurimath
  module Math
    class Symbol < Core
      attr_accessor :value

      def initialize(sym)
        @value = sym.is_a?(Parslet::Slice) ? sym.to_s : sym
      end

      def ==(object)
        object.value == value
      end

      def to_asciimath
        return "" if value.nil?

        symbol = Asciimath::Constants::SYMBOLS.invert[value.strip.to_sym]
        unicodes = Latex::Constants::UNICODE_SYMBOLS.invert
        if value.match?(/&#x[0-9\w]+;/) && symbol.nil? && unicodes[value]
          return unicodes[value].to_s
        end

        symbol ? symbol.to_s : value
      end

      def to_mathml_without_math_tag
        mi_tag = Utility.ox_element("mi")
        return mi_tag if ["{:", ":}"].include?(value)

        unicodes = Mathml::Constants::UNICODE_SYMBOLS
        unicode = unicodes.invert[value]
        if operator?(unicode) || unicode || explicit_checks(unicode)
          mo_value = (unicodes[value] || unicode || value).to_s
          return Utility.ox_element("mo") << mo_value
        end

        mi_tag << value
      end

      def to_latex
        returned = specific_values
        return returned if returned

        special_char = %w[&#x26; &#x23;]
        symbols = Latex::Constants::UNICODE_SYMBOLS.invert

        symbol = symbols[value]
        if Latex::Constants::SYMBOLS[symbol] == :operant
          special_char.include?(value) ? "\\#{symbol}" : symbol
        else
          symbols.key?(value) ? "\\#{symbol}" : value
        end
      end

      def to_html
        value
      end

      def to_omml_without_math_tag
        value
      end

      def insert_t_tag
        r_tag = Utility.ox_element("r", namespace: "m")
        r_tag << (Utility.ox_element("t", namespace: "m") << value)
        [r_tag]
      end

      def tag_name
        ["&#x22c0;", "&#x22c1;", "&#x22c2;", "&#x22c3;"].include?(value) ? "underover" : "subsup"
      end

      def omml_tag_name
        if ["&#x22c0;", "&#x22c1;", "&#x22c2;", "&#x22c3;", "&#x22c3;", "&#x2211;", "&#x220f;"].include?(value)
          return "undOvr"
        end

        "subSup"
      end

      def nary_attr_value
        value
      end

      def validate_function_formula
        false
      end

      private

      def operator?(unicode)
        Mathml::Constants::OPERATORS.any? do |d|
          [unicode.to_s, value.strip].include?(d)
        end
      end

      def explicit_checks(unicode)
        return true if [unicode, value].any? { |v| ["∣", "|"].include?(v) }
      end

      def specific_values
        return "" if ["{:", ":}"].include?(value)

        return "\\#{value}" if ["{", "}"].include?(value) || value == "_"

        return "\\operatorname{if}" if value == "if"
      end
    end
  end
end
