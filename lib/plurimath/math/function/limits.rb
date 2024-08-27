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

        def to_latex
          first_value  = parameter_one&.to_latex
          second_value = "{#{parameter_two.to_latex}}" if parameter_two
          third_value  = "{#{parameter_three.to_latex}}" if parameter_three
          "#{first_value}\\#{class_name}_#{second_value}^#{third_value}"
        end

        def to_omml_without_math_tag(display_style)
          underover(display_style)
        end

        def to_unicodemath
          "#{parameter_one&.to_unicodemath}#{sup_value}#{sub_value}"
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

        def sup_value
          return unless parameter_three

          if parameter_three.is_a?(Math::Function::Power)
            "┴#{parameter_three.to_unicodemath}"
          elsif parameter_one.is_a?(Math::Function::Power) && parameter_one&.prime_unicode?(parameter_one&.parameter_two)
            "┴#{parameter_three.to_unicodemath}"
          else
            "┴#{unicodemath_parens(parameter_three)}"
          end
        end

        def sub_value
          return unless parameter_two

          if parameter_two.is_a?(Math::Function::Base)
            "┬#{parameter_two.to_unicodemath}"
          else
            "┬#{unicodemath_parens(parameter_two)}"
          end
        end
      end
    end
  end
end
