# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Fenced < TernaryFunction
        def to_asciimath
          first_value  = parameter_one ? parameter_one.to_asciimath : "("
          second_value = parameter_two&.map(&:to_asciimath)&.join(",")
          third_value  = parameter_three ? parameter_three.to_asciimath : ")"
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag
          first_value  = parameter_one.value
          second_value = parameter_two.map(&:to_mathml_without_math_tag).join
          third_value  = parameter_three.value
          "<mfenced open='#{first_value}' close='#{third_value}'>"\
            "#{second_value}"\
            "</mfenced>"
        end
      end
    end
  end
end
