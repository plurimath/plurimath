# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sin
        attr_accessor :angle

        def initialize(angle)
          @angle = angle
        end

        def to_asciimath
          "sin#{angle&.to_asciimath}"
        end
      end
    end
  end
end
