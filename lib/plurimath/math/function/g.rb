# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class G < UnaryFunction
        def to_asciimath
          "g#{parameter_one&.to_asciimath}"
        end

        def to_latex
          "g#{parameter_one&.to_latex}"
        end
      end
    end
  end
end
