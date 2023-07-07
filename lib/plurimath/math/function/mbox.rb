# frozen_string_literal: true

require_relative "unary_function"
module Plurimath
  module Math
    module Function
      class Mbox < UnaryFunction
        def to_mathml_without_math_tag
          text = Utility.ox_element("mtext")
          text << (parameter_one.to_mathml_without_math_tag) if parameter_one
          text
        end

        def to_latex
          first_value = parameter_one&.to_latex
          "\\mbox{#{first_value}}"
        end

        def to_html
          parameter_one&.to_html
        end

        def to_omml_without_math_tag
          omml_value
        end
      end
    end
  end
end
