# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Ul
        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def ==(object)
          object == value
        end
      end
    end
  end
end
