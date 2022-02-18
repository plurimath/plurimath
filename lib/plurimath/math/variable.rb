# frozen_string_literal: true

module Plurimath
  module Math
    class Variable
      attr_accessor :value

      def initialize(value)
        @value = value
      end
    end
  end
end
