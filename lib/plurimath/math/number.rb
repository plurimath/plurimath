# frozen_string_literal: true

module Plurimath
  module Math
    class Number < Core
      attr_accessor :value

      def initialize(value)
        @value = value.is_a?(Parslet::Slice) ? value.to_s : value
      end

      def ==(object)
        object.value == value
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

      def to_omml_without_math_tag
        [(Utility.ox_element("t", namespace: "m") << value)]
      end

      def insert_t_tag
        r_tag = Utility.ox_element("r", namespace: "m")
        r_tag << (Utility.ox_element("t", namespace: "m") << value)
        [r_tag]
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
