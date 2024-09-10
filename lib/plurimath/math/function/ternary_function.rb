# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class TernaryFunction < Core
        attr_accessor :parameter_one, :parameter_two, :parameter_three, :hide_function_name

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       parameter_three = nil)
          @parameter_one = parameter_one
          @parameter_two = parameter_two
          @parameter_three = parameter_three
          Utility.validate_left_right(variables.map { |var| get(var) })
        end

        def ==(object)
          self.class == object.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two &&
            object.parameter_three == parameter_three
        end

        def to_asciimath(options:)
          first_value = first_field_wrap(parameter_one, options: options) if parameter_one
          second_value = "_#{wrapped(parameter_two, options: options)}" if parameter_two
          third_value = "^#{wrapped(parameter_three, options: options)}" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          value_arr = [
            validate_mathml_fields(parameter_one, intent, options: options),
            validate_mathml_fields(parameter_two, intent, options: options),
            validate_mathml_fields(parameter_three, intent, options: options),
          ]
          class_tag = ox_element("m#{class_name}")
          Utility.update_nodes(class_tag, value_arr)
        end

        def to_latex(options:)
          first_value  = parameter_one&.to_latex(options: options)
          second_value = parameter_two&.to_latex(options: options)
          third_value  = parameter_three&.to_latex(options: options)
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_html(options:)
          first_value  = "<i>#{parameter_one.to_html(options: options)}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html(options: options)}</i>" if parameter_two
          third_value = "<i>#{parameter_three.to_html(options: options)}</i>" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def any_value_exist?
          !(parameter_one.nil? || parameter_two.nil? || parameter_three.nil?)
        end

        def all_values_exist?
          !(parameter_one.nil? && parameter_two.nil? && parameter_three.nil?)
        end

        def to_asciimath_math_zone(spacing, last = false, _, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{to_asciimath(options: options)}\" #{parameters[:name]}\n"]
          ascii_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr, options: options })
          ascii_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr, options: options })
          ascii_fields_to_print(parameter_three, { spacing: new_spacing, field_name: parameters[:third_value], additional_space: "   |_ ", array: new_arr, options: options })
          new_arr
        end

        def to_latex_math_zone(spacing, last = false, _, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{to_latex(options: options)}\" #{parameters[:name]}\n"]
          latex_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr, options: options })
          latex_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr, options: options })
          latex_fields_to_print(parameter_three, { spacing: new_spacing, field_name: parameters[:third_value], additional_space: "   |_ ", array: new_arr, options: options })
          new_arr
        end

        def to_mathml_math_zone(spacing, last = false, _, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{dump_mathml(self, options: options)}\" #{parameters[:name]}\n"]
          mathml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr, options: options })
          mathml_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr, options: options })
          mathml_fields_to_print(parameter_three, { spacing: new_spacing, field_name: parameters[:third_value], additional_space: "   |_ ", array: new_arr, options: options })
          new_arr
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{dump_omml(self, display_style, options: options)}\" #{parameters[:name]}\n"]
          omml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr, display_style: display_style, options: options })
          omml_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr, display_style: display_style, options: options })
          omml_fields_to_print(parameter_three, { spacing: new_spacing, field_name: parameters[:third_value], additional_space: "   |_ ", array: new_arr, display_style: display_style, options: options })
          new_arr
        end

        def to_unicodemath_math_zone(spacing, last = false, _, options:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{to_unicodemath(options: options)}\" #{parameters[:name]}\n"]
          unicodemath_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr, options: options })
          unicodemath_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr, options: options })
          unicodemath_fields_to_print(parameter_three, { spacing: new_spacing, field_name: parameters[:third_value], additional_space: "   |_ ", array: new_arr, options: options })
          new_arr
        end

        protected

        def latex_wrapped(field, options:)
          field_value = field.to_latex(options: options)
          if field.validate_function_formula
            "{ \\left ( #{field_value} \\right ) }"
          else
            "{#{field_value}}"
          end
        end

        def wrapped(field, type: "ascii", options:)
          return "" unless field

          type == "ascii" ? "(#{field.to_asciimath(options: options)})" : "{#{field.to_latex(options: options)}}"
        end

        def first_field_wrap(field, type: "ascii", options:)
          return "" unless field

          type == "ascii" ? ascii_wrap(field, options: options) : latex_wrap(field, options: options)
        end

        def ascii_wrap(field, options:)
          asciimath = field.to_asciimath(options: options)
          return asciimath if ["obrace", "ubrace"].include?(field.class_name)

          case field
          when Formula || field.class.name.include?("Function")
            "(#{asciimath})"
          else
            asciimath
          end
        end

        def latex_wrap(field, options:)
          latex = field.to_latex(options: options)
          return latex if ["obrace", "ubrace"].include?(field.class_name)

          case field
          when Formula || field.class.name.include?("Function")
            "{#{latex}}"
          else
            latex
          end
        end

        def narypr(function_symbol, function_type: "undOvr")
          chr_arg     = { "m:val": function_symbol }
          limloc_arg  = { "m:val": function_type }
          subhide_arg = { "m:val": parameter_one ? "0" : "1" }
          suphide_arg = { "m:val": parameter_two ? "0" : "1" }
          chr_tag     = Utility.ox_element("chr", attributes: chr_arg, namespace: "m")
          limloc_tag  = Utility.ox_element("limLoc", attributes: limloc_arg, namespace: "m")
          subhide_tag = Utility.ox_element("subHide", attributes: subhide_arg, namespace: "m")
          suphide_tag = Utility.ox_element("supHide", attributes: suphide_arg, namespace: "m")
          nary_pr_tag = Utility.ox_element("naryPr", namespace: "m")
          Utility.update_nodes(
            nary_pr_tag,
            [
              chr_tag,
              limloc_tag,
              subhide_tag,
              suphide_tag,
            ],
          )
        end

        def validate_mathml_tag(parameter, intent, options:)
          return Array(Utility.ox_element("mrow")) unless parameter

          Array(parameter.to_mathml_without_math_tag(intent, options: options))
        end

        def underover(display_style, options:)
          overset = Overset.new(parameter_one, parameter_three)
          return overset.to_omml_without_math_tag(display_style, options: options) unless parameter_two

          Underset.new(overset, parameter_two)&.to_omml_without_math_tag(display_style, options: options)
        end

        def naryand_value(field, options:)
          return "" unless field

          field_value = field.to_unicodemath(options: options)
          field.is_a?(Math::Function::Fenced) ? "▒#{field_value}" : "▒〖#{field_value}〗"
        end
      end
    end
  end
end
