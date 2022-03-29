# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sech
        attr_accessor :angle

        def initialize(angle)
          @angle = angle
        end

        def to_asciimath
          "sech#{angle&.to_asciimath}"
        end

        def ==(object)
          object == angle
        end
      end
    end
  end
end
