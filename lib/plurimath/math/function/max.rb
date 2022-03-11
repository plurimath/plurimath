# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Max
        attr_accessor :values

        def initialize(values)
          @values = values
        end

        def to_asciimath
          "max#{values&.to_asciimath}"
        end
      end
    end
  end
end
