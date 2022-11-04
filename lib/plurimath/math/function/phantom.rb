# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Phantom < UnaryFunction
        def to_asciimath
          "\"#{Array.new(parameter_one.length, ' ').join}\""
        end
      end
    end
  end
end
