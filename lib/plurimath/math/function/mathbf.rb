# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Mathbf
        attr_accessor :text

        def initialize(text)
          @text = text
        end

        def ==(object)
          object == text
        end
      end
    end
  end
end
