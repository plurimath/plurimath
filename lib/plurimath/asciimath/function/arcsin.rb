# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Arcsin
        attr_accessor :angle

        def initialize(angle)
          @angle = angle
        end
      end
    end
  end
end
