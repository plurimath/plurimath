# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      attr_accessor :value

      def initialize(value = [])
        @value = value.is_a?(Array) ? value : [value]
      end

      def ==(object)
        object == value
      end

      def to_asciimath
        entities = ""
        value.each do |entity|
          entities += entity.to_asciimath
        end
        entities
      end
    end
  end
end
