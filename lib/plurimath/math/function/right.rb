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
          mo = Utility.ox_element("mo")
          mo << right_paren if parameter_one
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
          prefix = "\\" if parameter_one == "}"
          "\\right #{prefix}#{parameter_one}"
        end

        protected

        def right_paren
          return "}" if parameter_one == "\\}"

          parameter_one
        end
      end
    end
  end
end
