# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Det
        attr_accessor :scalar

        def initialize(scalar)
          @scalar = scalar
        end
      end
    end
  end
end
