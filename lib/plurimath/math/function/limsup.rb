# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Limsup < UnaryFunction
        def to_omml_without_math_tag(display_style)
          [r_element("limsup", rpr_tag: false), omml_value(display_style)]
        end
      end
    end
  end
end
