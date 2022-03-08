# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sec
        attr_accessor :angle

        def initialize(angle)
          @angle = angle
        end

        def to_asciimath
          "sec#{angle&.to_asciimath}"
        end
      end
    end
  end
end
