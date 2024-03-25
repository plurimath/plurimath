# frozen_string_literal: true

module Plurimath
  module Math
    class Number < Core
      attr_accessor :value, :mini_sub_sized, :mini_sup_sized

      def initialize(value, mini_sub_sized: false, mini_sup_sized: false)
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

      def to_asciimath
        value
      end

      def to_mathml_without_math_tag
        Utility.ox_element("mn") << value
      end

      def to_latex
        value
      end

      def to_html
        value
      end

      def to_omml_without_math_tag(_)
        [t_tag]
      end

      def to_unicodemath
        return mini_sub if mini_sub_sized
        return mini_sup if mini_sup_sized

        value
      end

      def insert_t_tag(_)
        [
          (Utility.ox_element("r", namespace: "m") << t_tag),
        ]
      end

      def font_style_t_tag(_)
        t_tag
      end

      def t_tag
        Utility.ox_element("t", namespace: "m") << value
      end

      def nary_attr_value
        value
      end

      def validate_function_formula
        false
      end

      def mini_sized?
        mini_sub_sized || mini_sup_sized
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
    end
  end
end
