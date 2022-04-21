# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Table < UnaryFunction
        def to_asciimath
          "[#{parameter_one.to_asciimath(",")}]"
        end
      end
    end
  end
end
