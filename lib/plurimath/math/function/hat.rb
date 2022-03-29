# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Hat
        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def to_asciimath
          "hat#{value&.to_asciimath}"
        end

        def ==(object)
          object == value
        end
      end
    end
  end
end
