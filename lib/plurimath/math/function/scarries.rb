# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Scarries < UnaryFunction
        def to_omml_without_math_tag
          omml_value
        end
      end
    end
  end
end
