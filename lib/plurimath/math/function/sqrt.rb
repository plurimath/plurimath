# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sqrt
        attr_accessor :number

        def initialize(number)
          @number = number
        end

        def ==(object)
          object == number
        end
      end
    end
  end
end
