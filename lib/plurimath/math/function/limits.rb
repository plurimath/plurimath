# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Limits < TernaryFunction
        FUNCTION = {
          name: "function apply",
          first_value: "base",
          second_value: "subscript",
          third_value: "supscript",
        }.freeze

        def to_mathml_without_math_tag(intent, options:)
          underover = Utility.ox_element("munderover")
          value_array = [
            validate_mathml_fields(parameter_one, intent, options: options),
            validate_mathml_fields(parameter_two, intent, options: options),
            validate_mathml_fields(parameter_three, intent, options: options),
          ]
          Utility.update_nodes(underover, value_array)
        end

        def to_latex(options:)
          first_value  = parameter_one&.to_latex(options: options)
          second_value = "{#{parameter_two.to_latex(options: options)}}" if parameter_two
          third_value  = "{#{parameter_three.to_latex(options: options)}}" if parameter_three
          "#{first_value}\\#{class_name}_#{second_value}^#{third_value}"
        end

        def to_omml_without_math_tag(display_style, options:)
          underover(display_style, options: options)
        end

        def to_unicodemath(options:)
          "#{parameter_one&.to_unicodemath(options: options)}#{sup_value(options: options)}#{sub_value(options: options)}"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two, parameter_three))
            self.parameter_two = nil
            self.parameter_three = nil
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(nil, Utility.filter_values(obj.value), parameter_three))
            self.parameter_three = nil
          end
        end

        protected

        def sup_value(options:)
          return unless parameter_three

          if parameter_three.is_a?(Math::Function::Power)
            "┴#{parameter_three.to_unicodemath(options: options)}"
          elsif parameter_one.is_a?(Math::Function::Power) && parameter_one&.prime_unicode?(parameter_one&.parameter_two)
            "┴#{parameter_three.to_unicodemath(options: options)}"
          else
            "┴#{unicodemath_parens(parameter_three, options: options)}"
          end
        end

        def sub_value(options:)
          return unless parameter_two

          if parameter_two.is_a?(Math::Function::Base)
            "┬#{parameter_two.to_unicodemath(options: options)}"
          else
            "┬#{unicodemath_parens(parameter_two, options: options)}"
          end
        end
      end
    end
  end
end
