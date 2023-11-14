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

        def to_mathml_without_math_tag
          underover = Utility.ox_element("munderover")
          value_array = [
            validate_mathml_fields(parameter_one),
            validate_mathml_fields(parameter_two),
            validate_mathml_fields(parameter_three),
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
          value_array = []
          value_array << parameter_one.insert_t_tag(display_style) if parameter_one
          value_array << parameter_two.insert_t_tag(display_style) if parameter_two
          value_array << parameter_three.insert_t_tag(display_style) if parameter_three
          value_array
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
      end
    end
  end
end
