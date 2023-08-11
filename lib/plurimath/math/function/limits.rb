# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Limits < TernaryFunction
        def to_mathml_without_math_tag
          underover = Utility.ox_element("munderover")
          value_array = []
          value_array << parameter_one&.to_mathml_without_math_tag
          value_array << parameter_two&.to_mathml_without_math_tag
          value_array << parameter_three&.to_mathml_without_math_tag
          Utility.update_nodes(underover, value_array)
        end

        def to_latex
          first_value  = parameter_one&.to_latex
          second_value = "{#{parameter_two.to_latex}}" if parameter_two
          third_value  = "{#{parameter_three.to_latex}}" if parameter_three
          "#{first_value}\\#{class_name}_#{second_value}^#{third_value}"
        end

        def to_omml_without_math_tag(display_style)
          value_array = []
          value_array << parameter_one.insert_t_tag(display_style) if parameter_one
          value_array << parameter_two.insert_t_tag(display_style) if parameter_two
          value_array << parameter_three.insert_t_tag(display_style) if parameter_three
          value_array
        end
      end
    end
  end
end
