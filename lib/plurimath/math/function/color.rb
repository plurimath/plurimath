# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Color < BinaryFunction
        def to_asciimath
          first_value = "(#{parameter_one&.to_asciimath&.gsub(/\s/, '')})"
          second_value = "(#{parameter_two&.to_asciimath})"
          "color#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element(
              "mstyle",
              attributes: { mathcolor: parameter_one&.to_asciimath&.gsub(/\s/, "")&.gsub(/"/, "") },
            ),
            [parameter_two&.to_mathml_without_math_tag],
          )
        end

        def to_latex
          first_value = parameter_one&.to_asciimath&.gsub(/\s/, "")
          second_value = parameter_two&.to_latex
          "{\\#{class_name}{#{first_value}} #{second_value}}"
        end

        def to_omml_without_math_tag(display_style)
          Array(parameter_two.insert_t_tag(display_style))
        end
      end
    end
  end
end
