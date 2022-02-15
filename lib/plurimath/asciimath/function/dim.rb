# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Dim
        attr_accessor :dimensions

        def initialize(dimensions)
          @dimensions = dimensions
        end
      end
    end
  end
end
