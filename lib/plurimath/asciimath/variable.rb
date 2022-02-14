# frozen_string_literal: true

module Plurimath
  class Asciimath
    # Variable Class
    class Variable
      attr_accessor :value

      def initialize(value)
        @value = value
      end
    end
  end
end
