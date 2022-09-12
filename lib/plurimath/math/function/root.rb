# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Root < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          "<mroot>#{first_value}#{second_value}</mroot>"
        end

        def to_latex
          first_value = parameter_one&.to_latex
          second_value = parameter_two&.to_latex
          "\\sqrt[#{first_value}]{#{second_value}}"
        end
      end
    end
  end
end
