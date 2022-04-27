# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Mathbb < UnaryFunction
        def to_mathml_without_math_tag
          "<mstyle mathvariant='double-struck'>#{parameter_one.to_mathml_without_math_tag}</mstyle>"
        end
      end
    end
  end
end
