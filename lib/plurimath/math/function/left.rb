# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Left < UnaryFunction
        def to_asciimath
          "left#{parameter_one}"
        end

        def to_mathml_without_math_tag
          Utility.omml_element("mi") << parameter_one
        end

        def to_latex
          prefix = "\\" if parameter_one == "{"
          "\\left#{prefix}#{parameter_one}"
        end
      end
    end
  end
end
