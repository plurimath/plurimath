# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Sqrt
        attr_accessor :number

        def initialize(number)
          @number = number
        end
      end
    end
  end
end
