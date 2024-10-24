# frozen_string_literal: true

require_relative "../mathml/utility"

module Plurimath
  module Math
    class Number < Core
      attr_accessor :value, :mini_sub_sized, :mini_sup_sized
      include Mathml::Utility

      def initialize(value = nil, mini_sub_sized: false, mini_sup_sized: false)
        @value = value.is_a?(Parslet::Slice) ? value.to_s : value
        @mini_sub_sized = mini_sub_sized if mini_sub_sized
        @mini_sup_sized = mini_sup_sized if mini_sup_sized
      end

      def ==(object)
        object.respond_to?(:value) &&
          object.value == value &&
          object.mini_sub_sized == mini_sub_sized &&
          object.mini_sup_sized == mini_sup_sized
      end

      def element_order=(*); end

      def to_asciimath(options:)
        format_value_with_options(options)
      end

      def to_mathml_without_math_tag(_, options:)
        Utility.ox_element("mn") << format_value_with_options(options)
      end

      def to_latex(options:)
        format_value_with_options(options)
      end

      def to_html(options:)
        format_value_with_options(options)
      end

      def to_omml_without_math_tag(_, options:)
        [t_tag(options: options)]
      end

      def to_unicodemath(options:)
        return mini_sub if mini_sub_sized
        return mini_sup if mini_sup_sized

        format_value_with_options(options)
      end

      def insert_t_tag(_, options:)
        [
          (Utility.ox_element("r", namespace: "m") << t_tag(options: options)),
        ]
      end

      def font_style_t_tag(_, options:)
        t_tag(options: options)
      end

      def t_tag(options:)
        Utility.ox_element("t", namespace: "m") << format_value_with_options(options)
      end

      def nary_attr_value(options:)
        format_value_with_options(options)
      end

      def validate_function_formula
        false
      end

      def mini_sized?
        mini_sub_sized || mini_sup_sized
      end

      def value=(value)
        @value = value.is_a?(Array) ? value.join : value
      end

      protected

      def mini_sub
        unicode_const(:SUB_DIGITS)[value.to_sym]
      end

      def mini_sup
        unicode_const(:SUP_DIGITS)[value.to_sym]
      end

      def unicode_const(const)
        UnicodeMath::Constants.const_get(const)
      end

      def format_value_with_options(options)
        return value unless options[:formatter]&.respond_to?(:localized_number)

        options[:formatter].localized_number(value.to_s)
      end
    end
  end
end
