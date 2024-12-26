# frozen_string_literal: true

require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Symbols
      class Symbol < Core
        include Mathml::Utility

        attr_accessor :value, :slashed, :mini_sub_sized, :mini_sup_sized, :options

        INPUT = {}.freeze

        def initialize(sym = nil,
                       slashed = nil,
                       mini_sub_sized: false,
                       mini_sup_sized: false,
                       options: {})
          @value = sym.is_a?(Array) ? sym.join : sym&.to_s
          @slashed = slashed if slashed
          @mini_sub_sized = mini_sub_sized if mini_sub_sized
          @mini_sup_sized = mini_sup_sized if mini_sup_sized
          @options = options unless options.empty?
        end

        def ==(object)
          object.respond_to?(:value) &&
            object.class == self.class &&
            object.value == value &&
            object.slashed == slashed &&
            object.mini_sub_sized == mini_sub_sized &&
            object.mini_sup_sized == mini_sup_sized &&
            object.options == options
        end

        def to_asciimath(**)
          return "" if value.nil?

          value
        end

        def value=(value)
          @value = value.is_a?(Array) ? value.join : value&.to_s
        end

        def to_mathml_without_math_tag(intent, **)
          attributes = {}
          if value&.include?("&#x2147;")
            attributes[:intent] = Utility.html_entity_to_unicode(value)
          end
          attributes[:rspace] = @options[:rspace] if @options&.key?(:rspace)
          mi_tag = ox_element("mi", attributes: attributes)
          return mi_tag if ["{:", ":}"].include?(value)

          value ? mi_tag << value : mi_tag
        end

        def to_latex(**)
          returned = specific_values
          return returned if returned

          value
        end

        def to_html(**)
          value
        end

        def to_omml_without_math_tag(_, **)
          # TODO: remove this condition once to word rendering issue is resolved, plurimath/plurimath/pull/328
          return if value == "&#x2062;"

          value
        end

        def to_unicodemath(**)
          return "\\#{value}" if slashed || special_chars
          return mini_sub if mini_sub_sized
          return mini_sup if mini_sup_sized

          value
        end

        def insert_t_tag(_, options:)
          # TODO: remove this condition once to word rendering issue is resolved, plurimath/plurimath/pull/328
          return if value == "&#x2062;"

          [(Utility.ox_element("r", namespace: "m") << t_tag(options: options))]
        end

        def tag_name
          "subsup"
        end

        def omml_tag_name
          "subSup"
        end

        def font_style_t_tag(_, options:)
          t_tag(options: options)
        end

        def nary_attr_value(options:)
          value || Utility.html_entity_to_unicode(to_omml_without_math_tag(true, options: options))
        end

        def validate_function_formula
          false
        end

        def omml_nodes(_, options:)
          Array(t_tag(options: options))
        end

        def t_tag(options:)
          output = value || to_omml_without_math_tag(nil, options: options)
          return t_element unless output

          t_element << output
        end

        def separate_table
          ["&", "\\\\"].include?(value) ||
            self.is_a?(Math::Symbols::Ampersand)
        end

        def linebreak?
          value == "\\\\"
        end

        def mini_sized?
          mini_sub_sized || mini_sup_sized
        end

        def to_asciimath_math_zone(spacing = "", last = false, indent = true, options:)
          "#{spacing}\"#{to_asciimath(options: options)}\" text\n"
        end

        def to_latex_math_zone(spacing = "", last = false, indent = true, options:)
          "#{spacing}\"#{to_latex(options: options)}\" text\n"
        end

        def to_omml_math_zone(spacing = "", last = false, indent = true, display_style:, options:)
          "#{spacing}\"#{dump_omml(self, display_style, options: options)}\" text\n"
        end

        def to_mathml_math_zone(spacing = "", last = false, indent = true, options:)
          "#{spacing}\"#{dump_mathml(self, options: options)}\" text\n"
        end

        def to_unicodemath_math_zone(spacing = "", last = false, indent = true, options:)
          "#{spacing}\"#{to_unicodemath(options: options)}\" text\n"
        end

        def paren?
          false
        end

        def input(lang)
          self.class.input(lang)
        end

        def self.input(lang)
          self::INPUT[lang]
        end

        private

        def t_element
          Utility.ox_element("t", namespace: "m")
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

        def parsing_wrapper(string, lang:)
          case lang
          when :asciimath, :unicode then "\"P{#{string}}\""
          when :latex then "\\text{P[#{string}]}"
          end
        end

        def self.parsing_wrapper(input_arr, lang:)
          input_arr.map do |input|
            case lang
            when :asciimath, :unicode then "\"P{#{input}}\""
            when :latex then "\\text{P[#{input}]}"
            end
          end
        end
      end
    end
  end
end
