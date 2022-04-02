# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Text < UnaryFunction
        def to_asciimath
          "\"#{parameter_one}\""
        end
      end
    end
  end
end
