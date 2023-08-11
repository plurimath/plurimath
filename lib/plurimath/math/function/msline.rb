# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Msline < UnaryFunction
        def to_omml_without_math_tag(display_style)
          omml_value(display_style)
        end
      end
    end
  end
end
