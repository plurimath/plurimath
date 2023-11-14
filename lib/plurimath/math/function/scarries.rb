# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Scarries < UnaryFunction
        def to_mathml_without_math_tag
          mathml_value
        end

        def to_omml_without_math_tag(display_style)
          omml_value(display_style)
        end
      end
    end
  end
end
