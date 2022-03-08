# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Mathcal
        attr_accessor :text

        def initialize(text)
          @text = text
        end

        def to_asciimath
          "mathcal#{text&.to_asciimath}"
        end
      end
    end
  end
end
