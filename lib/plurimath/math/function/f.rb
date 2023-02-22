# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class F < UnaryFunction
        def to_asciimath
          "f#{parameter_one&.to_asciimath}"
        end

        def to_latex
          first_value = latex_value if parameter_one
          "f#{first_value}"
        end
      end
    end
  end
end
