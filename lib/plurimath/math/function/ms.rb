# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ms < UnaryFunction
        def to_mathml_without_math_tag
          ms = Utility.ox_element("ms")
          Utility.update_nodes(ms, mathml_value)
        end

        def to_asciimath
          "\"“#{asciimath_value}”\""
        end

        def to_latex
          "\\text{“#{latex_value}”}"
        end

        def to_omml_without_math_tag(display_style)
          [
            (Utility.ox_element("t", namespace: "m") << "“"),
            omml_value(display_style),
            (Utility.ox_element("t", namespace: "m") << "”"),
          ]
        end
      end
    end
  end
end
