# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      # Sin Class
      class Sin
        attr_accessor :angle

        def initialize(angle)
          @angle = angle
        end
      end
    end
  end
end
