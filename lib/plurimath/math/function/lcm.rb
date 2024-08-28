# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Lcm < UnaryFunction
        def validate_function_formula
          false
        end

        def to_asciimath(options:)
          first_value = " #{asciimath_value(options: options)}" if parameter_one
          "lcm#{first_value}"
        end

        def to_latex(options:)
          "lcm{#{latex_value(options: options)}}"
        end

        def to_omml_without_math_tag(display_style, options:)
          array = []
          array << r_element("lcm", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style, options: options))
          array
        end
      end
    end
  end
end
