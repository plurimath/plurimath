# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Substack < BinaryFunction
        def to_latex
          first_value  = parameter_one.to_latex if parameter_one
          second_value = "\\\\#{parameter_two.to_latex}" if parameter_two
          "\\#{class_name}{#{first_value}#{second_value}}"
        end

        def to_mathml_without_math_tag
          value_array = []
          value_array << parameter_one.to_mathml_without_math_tag if parameter_one
          value_array << parameter_two.to_mathml_without_math_tag if parameter_two
          Utility.update_nodes(Utility.ox_element("mtable"), value_array)
        end
      end
    end
  end
end
