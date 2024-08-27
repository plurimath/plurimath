# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ms < UnaryFunction
        def to_mathml_without_math_tag(intent, **)
          Utility.ox_element("ms") << parameter_one
        end

        def to_asciimath
          "\"“#{parameter_one}”\""
        end

        def to_latex
          "\\text{“#{parameter_one}”}"
        end

        def to_omml_without_math_tag(display_style)
          [
            (Utility.ox_element("t", namespace: "m") << "“#{parameter_one}”"),
          ]
        end

        def to_unicodemath
          Text.new(parameter_one).to_unicodemath
        end
      end
    end
  end
end
