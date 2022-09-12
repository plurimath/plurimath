# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Power < BinaryFunction
        def to_asciimath
          first_value = parameter_one.to_asciimath if parameter_one
          second_value = "^#{parameter_two.to_asciimath}" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          first_value = parameter_one.to_mathml_without_math_tag
          second_value = parameter_two.to_mathml_without_math_tag
          "<msup>#{first_value}#{second_value}</msup>"
        end

        def to_latex
          first_value = parameter_one.to_latex if parameter_one
          first_value  = "{#{first_value}}" if parameter_one.is_a?(Formula)
          second_value = parameter_two.to_latex
          "#{first_value}^{#{second_value}}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html}</sup>" if parameter_two
          "#{first_value}#{second_value}"
        end
      end
    end
  end
end
