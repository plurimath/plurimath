# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class None < UnaryFunction
        def to_mathml_without_math_tag
          ox_element("none")
        end

        def to_omml_without_math_tag(_)
          empty_tag
        end
      end
    end
  end
end
