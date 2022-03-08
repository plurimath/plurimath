# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class F
        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def to_asciimath
          "f#{value&.to_asciimath}"
        end
      end
    end
  end
end
