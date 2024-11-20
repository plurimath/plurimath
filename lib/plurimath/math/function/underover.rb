# frozen_string_literal: true

require_relative "../../mathml/utility"
require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Underover < TernaryFunction
        include Mathml::Utility

        FUNCTION = {
          name: "UnderOver",
          first_value: "base",
          second_value: "Under",
          third_value: "Over",
        }.freeze

        def to_asciimath(options:)
          first_value = first_field_wrap(parameter_one, options: options) if parameter_one
          second_value = "_#{wrapped(parameter_two, options: options)}" if parameter_two
          third_value = "^#{wrapped(parameter_three, options: options)}" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_latex(options:)
          first_value = first_field_wrap(parameter_one, type: "latex", options: options) if parameter_one
          second_value = "_#{wrapped(parameter_two, type: 'latex', options: options)}" if parameter_two
          third_value = "^#{wrapped(parameter_three, type: 'latex', options: options)}" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          Utility.update_nodes(
            ox_element("m#{class_name}"),
            [
              validate_mathml_fields(parameter_one, intent, options: options),
              validate_mathml_fields(parameter_two, intent, options: options),
              validate_mathml_fields(parameter_three, intent, options: options),
            ],
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          if !display_style
            power_base = PowerBase.new(parameter_one, parameter_two, parameter_three)
            return power_base.to_omml_without_math_tag(display_style, options: options)
          end

          underover(display_style, options: options)
        end

        def to_unicodemath(options:)
          sub_value = "┬#{unicodemath_parens(parameter_two, options: options)}" if parameter_two
          sup_value = "┴#{unicodemath_parens(parameter_three, options: options)}" if parameter_three
          "#{parameter_one&.to_unicodemath(options: options)}#{sub_value}#{sup_value}"
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

        def new_nary_function(fourth_value)
          Nary.new(parameter_one, parameter_two, parameter_three, fourth_value, { type: "undOvr" })
        end

        def is_nary_function?
          parameter_one.is_nary_function? || parameter_one.is_nary_symbol?
        end
      end
    end
  end
end
