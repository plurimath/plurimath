# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Right < UnaryFunction
        def to_asciimath
          "right#{parameter_one}"
        end

        def to_mathml_without_math_tag
          Utility.ox_element("mi") << parameter_one
        end

        def to_latex
          prefix = "\\" if parameter_one == "}"
          "\\right#{prefix}#{parameter_one}"
        end
      end
    end
  end
end
