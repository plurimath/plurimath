# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sinh
        attr_accessor :angle

        def initialize(angle)
          @angle = angle
        end

        def ==(object)
          object == angle
        end
      end
    end
  end
end
