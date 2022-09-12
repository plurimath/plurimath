# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Over < BinaryFunction
        def to_asciimath
          first_value = "(#{parameter_one.to_asciimath})" if parameter_one
          second_value = "(#{parameter_two.to_asciimath})" if parameter_two
          "overset#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          two_value = parameter_two&.to_mathml_without_math_tag
          "<mover>#{first_value}#{two_value}</mover>"
        end

        def to_latex
          first_value = parameter_one&.to_latex
          two_value = parameter_two&.to_latex
          "{#{first_value} \\over #{two_value}}"
        end
      end
    end
  end
end
