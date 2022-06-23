# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Frac < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one.to_mathml_without_math_tag if parameter_one
          two_value = parameter_two.to_mathml_without_math_tag if parameter_two
          "<mfrac>#{first_value}#{two_value}</mfrac>"
        end

        def to_latex
          first_value = parameter_one.to_latex if parameter_one
          two_value = parameter_two.to_latex if parameter_two
          "\\frac{#{first_value}}{#{two_value}}"
        end
      end
    end
  end
end
