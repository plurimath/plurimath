# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Root
        attr_accessor :index, :number

        def initialize(index, number)
          @index = index
          @number = number
        end

        def ==(object)
          object.index == index && object.number == number
        end
      end
    end
  end
end
