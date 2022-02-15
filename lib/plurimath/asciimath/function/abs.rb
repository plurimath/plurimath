# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Abs
        attr_accessor :value

        def initialize(value)
          @value = value
        end
      end
    end
  end
end
