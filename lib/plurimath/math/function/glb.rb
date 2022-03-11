# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Glb
        attr_accessor :values

        def initialize(values)
          @values = values
        end

        def to_asciimath
          "glb#{values&.to_asciimath}"
        end
      end
    end
  end
end
