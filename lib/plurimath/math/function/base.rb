# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Base < BinaryFunction
        def to_asciimath
          first_value = "#{parameter_one.to_asciimath}" if parameter_one
          second_value = "_#{parameter_two.to_asciimath}" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          "<msub>#{parameter_one.to_mathml_without_math_tag}#{parameter_two.to_mathml_without_math_tag}</msub>"
        end
      end
    end
  end
end
