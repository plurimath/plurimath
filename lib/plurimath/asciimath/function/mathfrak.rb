# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Mathfrak
        attr_accessor :text

        def initialize(text)
          @text = text
        end
      end
    end
  end
end
