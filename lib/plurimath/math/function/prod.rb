# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Prod < BinaryFunction
        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "prod#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\prod#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          first_value = Utility.ox_element("mo") << invert_unicode_symbols.to_s
          if parameter_one || parameter_two
            value_array = [first_value]
            value_array << parameter_one&.to_mathml_without_math_tag
            value_array << parameter_two&.to_mathml_without_math_tag
            tag_name = if parameter_two && parameter_one
                         "underover"
                       else
                         parameter_one ? "under" : "over"
                       end
            munderover_tag = Utility.ox_element("m#{tag_name}")
            Utility.update_nodes(
              munderover_tag,
              value_array,
            )
          else
            first_value
          end
        end

        def to_html
          first_value = "<sub>#{parameter_one.to_html}</sub>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html}</sup>" if parameter_two
          "<i>&prod;</i>#{first_value}#{second_value}"
        end
      end
    end
  end
end
