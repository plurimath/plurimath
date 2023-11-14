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
          Utility.update_nodes(
            ox_element("m#{class_name}"),
            [
              validate_mathml_fields(parameter_one),
              validate_mathml_fields(parameter_two),
              validate_mathml_fields(parameter_three),
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

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              Underover.new(Utility.filter_values(obj.value), parameter_two, parameter_three)
            )
            self.parameter_two = nil
            self.parameter_three = nil
            return
          end

          parameter_two.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              Underover.new(nil, Utility.filter_values(obj.value), parameter_three)
            )
            self.parameter_two = nil
            self.parameter_three = nil
          end
        end
      end
    end
  end
end
