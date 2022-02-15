# frozen_string_literal: true

module Plurimath
  class Asciimath
    module Function
      class Text
        attr_accessor :string

        def initialize(string)
          @string = string
        end
      end
    end
  end
end
