# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ceil < UnaryFunction
        def to_latex
          "{\\lceil #{latex_value} \\rceil}"
        end

        def to_mathml_without_math_tag
          left_value = Utility.ox_element("mo") << "&#x2308;"
          first_value = mathml_value&.insert(0, left_value)
          right_value = Utility.ox_element("mo") << "&#x2309;"
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            first_value << right_value,
          )
        end

        def to_omml_without_math_tag(display_style)
          lceil = Symbol.new("⌈")
          rceil = Symbol.new("⌉")
          fenced = Fenced.new(lceil, Array(parameter_one), rceil)
          Array(fenced.to_omml_without_math_tag(display_style))
        end

        def to_html
          first_value = "<i>#{parameter_one.to_html}</i>" if parameter_one
          "<i>&#x2308;</i>#{first_value}<i>&#x2309;</i>"
        end
      end
    end
  end
end
