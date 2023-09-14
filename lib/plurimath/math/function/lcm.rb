# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Lcm < UnaryFunction
        def validate_function_formula
          false
        end

        def to_asciimath
          first_value = " #{asciimath_value}" if parameter_one
          "lcm#{first_value}"
        end

        def to_latex
          "lcm{#{latex_value}}"
        end

        def to_omml_without_math_tag(display_style)
          array = []
          array << r_element("lcm", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style))
          array
        end
      end
    end
  end
end
