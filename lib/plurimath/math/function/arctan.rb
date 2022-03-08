# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Arctan
        attr_accessor :angle

        def initialize(angle)
          @angle = angle
        end

        def to_asciimath
          "arctan#{angle&.to_asciimath}"
        end
      end
    end
  end
end
