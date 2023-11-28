# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Scarries < UnaryFunction
        def to_asciimath
          asciimath_value
        end

        def to_latex
          latex_value
        end

        def to_mathml_without_math_tag
          scarries_tag = Utility.ox_element("mscarries")
          Utility.update_nodes(scarries_tag, mathml_value)
          scarries_tag
        end

        def to_omml_without_math_tag(display_style)
          omml_value(display_style)
        end
      end
    end
  end
end
