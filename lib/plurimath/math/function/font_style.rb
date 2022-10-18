# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class FontStyle < BinaryFunction
        def to_asciimath
          "#{parameter_two}#{parameter_one.to_asciimath}"
        end

        def to_mathml_without_math_tag
          first_value = parameter_one.to_mathml_without_math_tag
          "<mstyle mathvariant='#{parameter_two}'>#{first_value}</mstyle>"
        end

        def to_latex
          first_value = parameter_one.to_latex if parameter_one
          "\\#{parameter_two}{#{first_value}}"
        end
      end
    end
  end
end
