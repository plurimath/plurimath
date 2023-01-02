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
          mi = Utility.ox_element("mi")
          mi << parameter_one if parameter_one
          mi
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
          prefix = "\\" if parameter_one == "}"
          "\\right#{prefix}#{parameter_one}"
        end
      end
    end
  end
end
