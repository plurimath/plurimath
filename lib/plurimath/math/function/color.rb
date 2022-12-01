# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Color < BinaryFunction
        def to_asciimath
          first_value = parameter_one.parameter_one if parameter_one
          "color(#{first_value})#{wrapped(parameter_two)}"
        end

        def to_mathml_without_math_tag
          first_value  = parameter_one&.parameter_one
          second_value = parameter_two&.to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element(
              "mstyle",
              attributes: { mathcolor: first_value },
            ),
            [second_value],
          )
        end

        def to_latex
          first_value = parameter_one&.to_latex
          second_value = parameter_two&.to_latex
          "\\#{class_name}{#{first_value}}#{second_value}"
        end
      end
    end
  end
end
