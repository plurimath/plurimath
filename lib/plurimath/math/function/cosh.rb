# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Cosh
        attr_accessor :angle

        def initialize(angle)
          @angle = angle
        end

        def to_asciimath
          "cosh#{angle&.to_asciimath}"
        end
      end
    end
  end
end
