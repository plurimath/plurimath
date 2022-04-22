# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Table < UnaryFunction
        def to_asciimath
          "[#{parameter_one.map(&:to_asciimath).join(',')}]"
        end
      end
    end
  end
end
