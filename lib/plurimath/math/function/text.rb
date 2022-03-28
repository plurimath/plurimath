# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Text
        attr_accessor :string

        def initialize(string)
          @string = string
        end

        def ==(object)
          object == string
        end
      end
    end
  end
end
