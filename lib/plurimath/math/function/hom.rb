# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Hom < UnaryFunction
        def to_omml_without_math_tag
          [r_element("hom"), omml_value]
        end
      end
    end
  end
end
