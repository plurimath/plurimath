# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Number
      attr_accessor :value

      def initialize(value)
        @value = value
      end
    end
  end
end
