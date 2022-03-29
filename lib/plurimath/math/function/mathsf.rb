# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Mathsf
        attr_accessor :text

        def initialize(text)
          @text = text
        end

        def to_asciimath
          "mathsf#{text&.to_asciimath}"
        end

        def ==(object)
          object == text
        end
      end
    end
  end
end
