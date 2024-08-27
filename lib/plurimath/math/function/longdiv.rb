# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Longdiv < UnaryFunction
        def to_asciimath
          asciimath_value
        end

        def to_latex
          latex_value
        end

        def to_mathml_without_math_tag(intent, options:)
          Utility.update_nodes(
            ox_element("m#{class_name}"),
            mathml_value(intent, options: options),
          )
        end

        def to_omml_without_math_tag(display_style)
          omml_value(display_style)
        end

        def to_unicodemath
          parameter_one&.to_unicodemath
        end

        def line_breaking(obj)
          custom_array_line_breaking(obj)
        end
      end
    end
  end
end
