# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Obrace
        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def to_asciimath
          "obrace#{value&.to_asciimath}"
        end

        def ==(object)
          object == value
        end
      end
    end
  end
end
