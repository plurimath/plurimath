# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Bar
        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def to_asciimath
          "bar#{value&.to_asciimath}"
        end
      end
    end
  end
end
