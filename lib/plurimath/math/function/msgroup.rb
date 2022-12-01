# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Msgroup < UnaryFunction
        def to_asciimath
          parameter_one.map(&:to_asciimath).join
        end

        def to_latex
          parameter_one.map(&:to_latex).join
        end

        def to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element("msgroup"),
            parameter_one.map(&:to_mathml_without_math_tag),
          )
        end

        def to_html
          "<i>#{parameter_one.map(&:to_html)}</i>"
        end
      end
    end
  end
end
