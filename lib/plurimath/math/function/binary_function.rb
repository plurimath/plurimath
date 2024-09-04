# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class BinaryFunction < Core
        attr_accessor :parameter_one, :parameter_two, :hide_function_name

        def initialize(parameter_one = nil, parameter_two = nil)
          @parameter_one = parameter_one
          @parameter_two = parameter_two
          Utility.validate_left_right(variables.map { |var| get(var) })
        end

        def to_asciimath(options:)
          "#{class_name}#{wrapped(parameter_one, options: options)}#{wrapped(parameter_two, options: options)}"
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two
        end

        def to_mathml_without_math_tag(intent, options:)
          mrow_tag = Utility.ox_element("mrow")
          mo_tag = Utility.ox_element("mo") << invert_unicode_symbols.to_s
          first_value = parameter_one&.to_mathml_without_math_tag(intent, options: options) if parameter_one
          second_value = parameter_two&.to_mathml_without_math_tag(intent, options: options) if parameter_two
          Utility.update_nodes(
            mrow_tag,
            [
              first_value,
              mo_tag,
              second_value,
            ],
          )
        end

        def to_latex(options:)
          first_value = latex_wrapped(parameter_one, options: options) if parameter_one
          second_value = latex_wrapped(parameter_two, options: options) if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_html(options:)
          first_value = "<i>#{parameter_one.to_html(options: options)}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html(options: options)}</i>" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag(display_style, options:)
          r_tag = Utility.ox_element("r", namespace: "m")
          Utility.update_nodes(r_tag, [parameter_one.insert_t_tag(display_style, options: options)]) if parameter_one
          Utility.update_nodes(r_tag, [parameter_two.insert_t_tag(display_style, options: options)]) if parameter_two
          [r_tag]
        end

        def any_value_exist?
          !(parameter_one.nil? || parameter_two.nil?)
        end

        def all_values_exist?
          !(parameter_one.nil? && parameter_two.nil?)
        end

        def to_asciimath_math_zone(spacing, last = false, _, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{to_asciimath(options: options)}\" #{parameters[:name]}\n"]
          ascii_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ " , array: new_arr, options: options })
          ascii_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "   |_ " , array: new_arr, options: options })
          new_arr
        end

        def to_latex_math_zone(spacing, last = false, _, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{to_latex(options: options)}\" #{parameters[:name]}\n"]
          latex_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ " , array: new_arr, options: options })
          latex_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "   |_ " , array: new_arr, options: options })
          new_arr
        end

        def to_mathml_math_zone(spacing, last = false, _, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{dump_mathml(self, options: options)}\" #{parameters[:name]}\n"]
          mathml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr, options: options })
          mathml_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr, options: options })
          new_arr
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{dump_omml(self, display_style, options: options)}\" #{parameters[:name]}\n"]
          omml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr, display_style: display_style, options: options })
          omml_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr, display_style: display_style, options: options })
          new_arr
        end

        def to_unicodemath_math_zone(spacing, last = false, _, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{to_unicodemath(options: options)}\" #{parameters[:name]}\n"]
          unicodemath_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ " , array: new_arr, options: options })
          unicodemath_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "   |_ " , array: new_arr, options: options })
          new_arr
        end

        protected

        def latex_wrapped(field, options:)
          latex = field.to_latex(options: options)
          if field.validate_function_formula
            "{ \\left ( #{latex} \\right ) }"
          else
            "{#{latex}}"
          end
        end

        def wrapped(field, options:)
          return "" unless field

          "(#{field.to_asciimath(options: options)})"
        end

        def underover(display_style, options:)
          return r_element(class_name, rpr_tag: false) unless all_values_exist?

          first_value = Symbols::Symbol.new(class_name)
          if !display_style
            power_base = PowerBase.new(first_value, parameter_one, parameter_two)
            return power_base.to_omml_without_math_tag(display_style, options: options)
          end

          overset = Overset.new(first_value, parameter_two)
          return Array(overset.to_omml_without_math_tag(display_style, options: options)) unless parameter_one

          underset = Underset.new(overset, parameter_one)
          Array(underset.to_omml_without_math_tag(display_style, options: options))
        end
      end
    end
  end
end
