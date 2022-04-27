# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Mathcal < UnaryFunction
        def to_mathml_without_math_tag
          "<mstyle mathvariant='script'>#{parameter_one.to_mathml_without_math_tag}</mstyle>"
        end
      end
    end
  end
end
