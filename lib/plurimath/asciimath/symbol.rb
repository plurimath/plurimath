# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Symbol
      attr_accessor :value

      def initialize(sym)
        @value = sym
      end
    end
  end
end
