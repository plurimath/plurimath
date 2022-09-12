# frozen_string_literal: true

module Plurimath
  module Math
    class Number
      attr_accessor :value

      def initialize(value)
        @value = value
      end

      def ==(object)
        object.value == value
      end

      def to_asciimath
        value
      end

      def to_mathml_without_math_tag
        "<mn>#{value}</mn>"
      end

      def to_latex
        value
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
