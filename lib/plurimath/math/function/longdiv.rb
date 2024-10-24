# frozen_string_literal: true

require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Longdiv < UnaryFunction
        include Mathml::Utility

        def to_asciimath(options:)
          asciimath_value(options: options)
        end

        def to_latex(options:)
          latex_value(options: options)
        end

        def to_mathml_without_math_tag(intent, options:)
          Utility.update_nodes(
            ox_element("m#{class_name}"),
            mathml_value(intent, options: options),
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          omml_value(display_style, options: options)
        end

        def to_unicodemath(options:)
          parameter_one&.to_unicodemath(options: options)
        end

        def line_breaking(obj)
          custom_array_line_breaking(obj)
        end
      end
    end
  end
end
