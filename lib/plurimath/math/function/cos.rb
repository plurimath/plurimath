# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Cos
        attr_accessor :angle

        def initialize(angle)
          @angle = angle
        end

        def to_asciimath
          "cos#{angle&.to_asciimath}"
        end

        def ==(object)
          object.angle == angle
        end
      end
    end
  end
end
