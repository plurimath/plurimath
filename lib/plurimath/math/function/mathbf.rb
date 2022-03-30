# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Mathbf < UnaryFunction
        attr_accessor :text

        def initialize(text = nil)
          @text = text
        end
      end
    end
  end
end
