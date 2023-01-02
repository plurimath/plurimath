# frozen_string_literal: true

module Plurimath
  module Math
    class Number < Base
      attr_accessor :value

      def initialize(value)
        @value = super
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
        Utility.ox_element("t", namespace: "m") << value
      end

      def class_name
        self.class.name.split("::").last.downcase
      end
    end
  end
end
