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
          mo = Utility.ox_element("mo")
          mo << parameter_one if parameter_one
          mo
        end

        def to_omml_without_math_tag
          mt = Utility.ox_element("m:t")
          mt << parameter_one if parameter_one
          mt
        end

        def to_html
          "<i>#{parameter_one}</i>"
        end

        def to_latex
          prefix = "\\" if parameter_one == "{"
          "\\left #{prefix}#{parameter_one}"
        end
      end
    end
  end
end
