# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Lim < BinaryFunction
        FUNCTION = {
          name: "limit",
          first_value: "limit subscript",
          second_value: "limit supscript",
        }.freeze

        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "lim#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent)
          first_value = Utility.ox_element("mo") << "lim"
          return first_value unless all_values_exist?

          tag_name = if parameter_two && parameter_one
                       "underover"
                     else
                       parameter_one ? "under" : "over"
                     end
          lim_tag = Utility.ox_element("m#{tag_name}")
          Utility.update_nodes(
            lim_tag,
            [
              first_value,
              parameter_one&.to_mathml_without_math_tag(intent),
              parameter_two&.to_mathml_without_math_tag(intent),
            ],
          )
          intentify(lim_tag, intent, func_name: :function, intent_name: :function)
        end

        def to_omml_without_math_tag(display_style)
          underover(display_style)
        end

        def to_unicodemath
          first_value  = "_#{unicodemath_parens(parameter_one)}" if parameter_one
          second_value = "^#{unicodemath_parens(parameter_two)}" if parameter_two
          "lim#{first_value}#{second_value}"
        end

        def line_breaking(obj)
          parameter_one.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              Underover.new(nil, Utility.filter_values(obj.value), parameter_two)
            )
            self.parameter_two = nil
          end
        end
      end
    end
  end
end
