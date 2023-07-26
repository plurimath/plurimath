# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Gcd < UnaryFunction
        def validate_function_formula
          false
        end

        def to_omml_without_math_tag
          [r_element("gcd"), omml_value]
        end
      end
    end
  end
end
