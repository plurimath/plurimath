# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Underover < TernaryFunction
        FUNCTION = {
          name: "UnderOver",
          first_value: "base",
          second_value: "Under",
          third_value: "Over",
        }.freeze

        def to_asciimath
          first_value = first_field_wrap(parameter_one) if parameter_one
          second_value = "_#{wrapped(parameter_two)}" if parameter_two
          third_value = "^#{wrapped(parameter_three)}" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_latex
          first_value = first_field_wrap(parameter_one, type: "latex") if parameter_one
          second_value = "_#{wrapped(parameter_two, type: 'latex')}" if parameter_two
          third_value = "^#{wrapped(parameter_three, type: 'latex')}" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag
          first_value  = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          third_value  = parameter_three&.to_mathml_without_math_tag
          class_tag = Utility.ox_element("m#{class_name}")
          Utility.update_nodes(
            class_tag,
            [
              first_value,
              second_value,
              third_value,
            ],
          )
        end

        def to_omml_without_math_tag(display_style)
          if !display_style
            power_base = PowerBase.new(parameter_one, parameter_two, parameter_three)
            return power_base.to_omml_without_math_tag(display_style)
          end

          underover(display_style)
        end
      end
    end
  end
end
