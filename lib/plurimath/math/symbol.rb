# frozen_string_literal: true

module Plurimath
  module Math
    class Symbol < Core
      attr_accessor :value, :slashed, :mini_sub_sized, :mini_sup_sized, :options

      def initialize(sym = nil,
                     slashed = nil,
                     mini_sub_sized: false,
                     mini_sup_sized: false,
                     options: {})
        @value = sym.is_a?(Parslet::Slice) ? sym.to_s : sym
        @slashed = slashed if slashed
        @mini_sub_sized = mini_sub_sized if mini_sub_sized
        @mini_sup_sized = mini_sup_sized if mini_sup_sized
        @options = options unless options.empty?
      end

      def ==(object)
        object.respond_to?(:value) &&
          object.value == value &&
          object.slashed == slashed &&
          object.mini_sub_sized == mini_sub_sized &&
          object.mini_sup_sized == mini_sup_sized &&
          object.options == options
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

        unicode = Mathml::Constants::UNICODE_SYMBOLS.invert[value]
        if operator?(unicode) || unicode || explicit_checks(unicode)
          return Utility.ox_element("mo") << (unicode || value).to_s
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

      def to_omml_without_math_tag(_, _)
        value
      end

      def to_unicodemath
        return "\\#{value}" if slashed || special_chars
        return mini_sub if mini_sub_sized
        return mini_sup if mini_sup_sized

        value
      end

      def insert_t_tag(_)
        [(Utility.ox_element("r", namespace: "m") << t_tag)]
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

      def font_style_t_tag(_)
        t_tag
      end

      def nary_attr_value
        value
      end

      def validate_function_formula
        false
      end

      def omml_nodes(_)
        Array(t_tag)
      end

      def t_tag
        Utility.ox_element("t", namespace: "m") << value
      end

      def separate_table
        ["&", "\\\\"].include?(value)
      end

      def linebreak
        value == "\\\\"
      end

      def is_nary_symbol?
        %w[
          &#x222c;
          &#x222d;
          &#x222f;
          &#x2230;
          &#x2232;
          &#x2233;
          &#x2231;
          &#x2229;
          &#x222a;
          &#x2210;
        ].include?(value)
      end

      def mini_sized?
        mini_sub_sized || mini_sup_sized
      end

      private

      def operator?(unicode)
        Mathml::Constants::OPERATORS.any? do |d|
          [unicode.to_s, value.strip].include?(d)
        end
      end

      def explicit_checks(unicode)
        return true if [unicode, value].any? { |v| ["∣", "|"].include?(v) }
        return true if unicode_const(:ACCENT_SYMBOLS).has_value?(value)
      end

      def specific_values
        return "" if ["{:", ":}"].include?(value)

        return "\\#{value}" if ["{", "}"].include?(value) || value == "_"

        return "\\operatorname{if}" if value == "if"
      end

      def mini_sub
        unicode_const(:SUB_ALPHABETS)[value.to_sym] ||
          unicode_const(:SUB_OPERATORS)[value.to_sym] ||
          mini_sized_parenthesis(unicode_const(:SUB_PARENTHESIS))
      end

      def mini_sup
        unicode_const(:SUP_ALPHABETS)[value.to_sym] ||
          unicode_const(:SUP_OPERATORS)[value.to_sym] ||
          mini_sized_parenthesis(unicode_const(:SUP_PARENTHESIS))
      end

      def unicode_const(const)
        UnicodeMath::Constants.const_get(const)
      end

      def mini_sized_parenthesis(parens)
        parens.values.find { |paren| paren.dig(value.to_sym) }&.dig(value.to_sym)
      end

      def special_chars
        %w[& @ ^].include?(value)
      end
    end
  end
end
