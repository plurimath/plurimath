# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Root
        attr_accessor :index, :number

        def initialize(index, number)
          @index = index
          @number = number
        end
      end
    end
  end
end
