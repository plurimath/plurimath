# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Inf < BinaryFunction
        def to_asciimath
          first_value = "_(#{parameter_one.to_asciimath})" if parameter_one
          second_value = "^(#{parameter_two.to_asciimath})" if parameter_two
          "#{class_name}#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          first_value = Utility.ox_element("mo") << class_name
          return first_value unless all_values_exist?

          value_array = [first_value]
          value_array << parameter_one&.to_mathml_without_math_tag
          value_array << parameter_two&.to_mathml_without_math_tag
          tag_name = if parameter_two && parameter_one
                       "underover"
                     else
                       parameter_one ? "under" : "over"
                     end
          Utility.update_nodes(
            Utility.ox_element("m#{tag_name}"),
            value_array,
          )
        end

        def to_omml_without_math_tag(display_style)
          underover(display_style)
        end
      end
    end
  end
end
