# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Glb < UnaryFunction
        def validate_function_formula
          false
        end

        def to_latex
          "glb{#{latex_value}}"
        end

        def to_omml_without_math_tag(display_style)
          [r_element("glb", rpr_tag: false), omml_value(display_style)]
        end
      end
    end
  end
end
