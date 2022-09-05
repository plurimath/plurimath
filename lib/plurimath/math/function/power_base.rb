# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class PowerBase < TernaryFunction
        def to_mathml_without_math_tag
          first_value  = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          third_value  = parameter_three&.to_mathml_without_math_tag
          "<msubsup>#{first_value}#{second_value}#{third_value}</msubsup>"
        end

        def to_latex
          first_value  = parameter_one&.to_latex
          second_value = parameter_two&.to_latex
          third_value  = parameter_three&.to_latex
          first_value  = "{#{first_value}}" if parameter_one.is_a?(Formula)
          "#{first_value}_{#{second_value}}^{#{third_value}}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>"
          second_value = "<sub>#{parameter_two.to_html}</sub>"
          third_value  = "<sup>#{parameter_three.to_html}</sup>"
          "#{first_value}#{second_value}#{third_value}"
        end
      end
    end
  end
end
