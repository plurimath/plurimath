# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Dim
        attr_accessor :dimensions

        def initialize(dimensions)
          @dimensions = dimensions
        end

        def to_asciimath
          "dim#{dimensions&.to_asciimath}"
        end

        def ==(object)
          object == dimensions
        end
      end
    end
  end
end
