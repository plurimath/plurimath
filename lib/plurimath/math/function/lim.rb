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

        def to_asciimath(options:)
          first_value = "_#{wrapped(parameter_one, options: options)}" if parameter_one
          second_value = "^#{wrapped(parameter_two, options: options)}" if parameter_two
          "lim#{first_value}#{second_value}"
        end

        def to_latex(options:)
          first_value = "_{#{parameter_one.to_latex(options: options)}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex(options: options)}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
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
              parameter_one&.to_mathml_without_math_tag(intent, options: options),
              parameter_two&.to_mathml_without_math_tag(intent, options: options),
            ],
          )
          intentify(lim_tag, intent, func_name: :function, intent_name: intent_names[:name])
        end

        def to_omml_without_math_tag(display_style, options:)
          underover(display_style, options: options)
        end

        def to_unicodemath(options:)
          first_value  = "_#{unicodemath_parens(parameter_one, options: options)}" if parameter_one
          second_value = "^#{unicodemath_parens(parameter_two, options: options)}" if parameter_two
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

        def intent_names
          { name: ":function" }
        end
      end
    end
  end
end
