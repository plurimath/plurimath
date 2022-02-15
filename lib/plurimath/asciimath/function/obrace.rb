# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Obrace
        attr_accessor :value

        def initialize(value)
          @value = value
        end
      end
    end
  end
end
