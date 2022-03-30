# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Text < UnaryFunction
        attr_accessor :string

        def initialize(string = nil)
          @string = string
        end
      end
    end
  end
end
