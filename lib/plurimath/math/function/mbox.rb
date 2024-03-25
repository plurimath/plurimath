# frozen_string_literal: true

require_relative "unary_function"
module Plurimath
  module Math
    module Function
      class Mbox < UnaryFunction
        def to_asciimath
          Text.new(parameter_one).to_asciimath
        end

        def to_mathml_without_math_tag
          Text.new(parameter_one).to_mathml_without_math_tag
        end

        def to_latex
          "\\mbox{#{parameter_one}}"
        end

        def to_html
          parameter_one
        end

        def to_omml_without_math_tag(display_style)
          Text.new(parameter_one).to_omml_without_math_tag(display_style)
        end

        def to_unicodemath
          Text.new(parameter_one).to_unicodemath
        end
      end
    end
  end
end
