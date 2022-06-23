# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Overset < BinaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one.to_mathml_without_math_tag if parameter_one
          second_value = parameter_two.to_mathml_without_math_tag if parameter_two
          "<mover>#{second_value}#{first_value}</mover>"
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}" if parameter_one
          second_value = "#{parameter_two.to_latex}}" if parameter_two
          "#{first_value}\\over#{second_value}"
        end
      end
    end
  end
end
