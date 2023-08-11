# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Lg < UnaryFunction
        def validate_function_formula
          false
        end

        def to_omml_without_math_tag(display_style)
          [r_element("lg", rpr_tag: false), omml_value(display_style)]
        end
      end
    end
  end
end
