# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Left < UnaryFunction
        def to_asciimath
          "left#{value_to_asciimath}"
        end

        def value_to_asciimath
          "(#{parameter_one.to_asciimath}right)" if parameter_one
        end

        def to_latex
          "\\left(#{parameter_one&.to_latex}\\right)"
        end
      end
    end
  end
end
