# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Lcm < UnaryFunction
        def to_omml_without_math_tag
          [r_element("lcm"), omml_value]
        end
      end
    end
  end
end
