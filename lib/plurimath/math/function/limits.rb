# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Limits < TernaryFunction
        def to_latex
          first_value  = parameter_one&.to_latex
          second_value = "{#{parameter_two.to_latex}}" if parameter_two
          third_value  = "{#{parameter_three.to_latex}}" if parameter_three
          "#{first_value}\\#{class_name}_#{second_value}^#{third_value}"
        end
      end
    end
  end
end
