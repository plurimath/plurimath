# frozen_string_literal: true

module Plurimath
  module Math
    class Number < Core
      attr_accessor :value

      def initialize(value)
        @value = value.is_a?(Parslet::Slice) ? value.to_s : value
      end

      def ==(object)
        object.respond_to?(:value) && object.value == value
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

      def to_omml_without_math_tag(*)
        [t_tag]
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
    end
  end
end
