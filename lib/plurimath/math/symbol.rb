# frozen_string_literal: true

module Plurimath
  module Math
    class Symbol
      attr_accessor :value

      def initialize(sym)
        @value = sym
      end

      def to_asciimath
        value
      end
    end
  end
end
