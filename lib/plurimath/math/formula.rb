# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      attr_accessor :value

      def initialize(value = [])
        @value = value.is_a?(Array) ? value : [value]
      end

      def ==(object)
        object.value == value
      end

      def to_asciimath
        value.map(&:to_asciimath).join
      end

      def to_mathml
        <<~MATHML
          <math xmlns='http://www.w3.org/1998/Math/MathML' display='block'>
            <mstyle displaystyle='true'>
              #{mathml_content}
            </mstyle>
          </math>
        MATHML
      end

      def to_mathml_without_math_tag
        "<mrow>#{mathml_content}</mrow>"
      end

      def mathml_content
        value.map(&:to_mathml_without_math_tag).join
      end

      def to_latex
        value.map(&:to_latex).join
      end

      def to_html
        value.map(&:to_html).join
      end

      def class_name
        "formula"
      end
    end
  end
end
