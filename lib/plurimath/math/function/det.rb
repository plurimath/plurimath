# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Det
        attr_accessor :scalar

        def initialize(scalar)
          @scalar = scalar
        end

        def to_asciimath
          "det#{scalar&.to_asciimath}"
        end

        def ==(object)
          object == scalar
        end
      end
    end
  end
end
