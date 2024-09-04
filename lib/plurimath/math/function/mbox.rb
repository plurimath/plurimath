# frozen_string_literal: true

require_relative "unary_function"
module Plurimath
  module Math
    module Function
      class Mbox < UnaryFunction
        def to_asciimath(options:)
          Text.new(parameter_one).to_asciimath(options: options)
        end

        def to_mathml_without_math_tag(intent, options:)
          Text.new(parameter_one).to_mathml_without_math_tag(intent, options: options)
        end

        def to_latex(**)
          "\\mbox{#{parameter_one}}"
        end

        def to_html(**)
          parameter_one
        end

        def to_omml_without_math_tag(display_style, options:)
          Text.new(parameter_one).to_omml_without_math_tag(display_style, options: options)
        end

        def to_unicodemath(options:)
          Text.new(parameter_one).to_unicodemath(options: options)
        end
      end
    end
  end
end
