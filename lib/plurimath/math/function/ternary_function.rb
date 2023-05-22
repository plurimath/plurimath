# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class TernaryFunction < Core
        attr_accessor :parameter_one, :parameter_two, :parameter_three

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       parameter_three = nil)
          @parameter_one = parameter_one
          @parameter_two = parameter_two
          @parameter_three = parameter_three
          Utility.validate_left_right([parameter_one, parameter_two, parameter_three])
        end

        def to_asciimath
          first_value = first_field_wrap(parameter_one) if parameter_one
          second_value = "_#{wrapped(parameter_two)}" if parameter_two
          third_value = "^#{wrapped(parameter_three)}" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def ==(object)
          self.class == object.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two &&
            object.parameter_three == parameter_three
        end

        def to_mathml_without_math_tag
          value_arr = [parameter_one&.to_mathml_without_math_tag]
          value_arr << parameter_two&.to_mathml_without_math_tag
          value_arr << parameter_three&.to_mathml_without_math_tag
          class_tag = Utility.ox_element("m#{class_name}")
          Utility.update_nodes(class_tag, value_arr)
        end

        def to_latex
          first_value  = parameter_one&.to_latex
          second_value = parameter_two&.to_latex
          third_value  = parameter_three&.to_latex
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html}</i>" if parameter_two
          third_value = "<i>#{parameter_three.to_html}</i>" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def any_value_exist?
          !(parameter_one.nil? || parameter_two.nil? || parameter_three.nil?)
        end

        def all_values_exist?
          !(parameter_one.nil? && parameter_two.nil? && parameter_three.nil?)
        end

        def to_asciimath_math_zone(spacing, last = false, indent = true)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{to_asciimath}\" #{parameters[:name]}\n"]
          ascii_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr })
          ascii_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr })
          ascii_fields_to_print(parameter_three, { spacing: new_spacing, field_name: parameters[:third_value], additional_space: "   |_ ", array: new_arr })
          new_arr
        end

        def to_latex_math_zone(spacing, last = false, indent = true)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{to_latex}\" #{parameters[:name]}\n"]
          latex_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr })
          latex_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr })
          latex_fields_to_print(parameter_three, { spacing: new_spacing, field_name: parameters[:third_value], additional_space: "   |_ ", array: new_arr })
          new_arr
        end

        def to_mathml_math_zone(spacing, last = false, indent = true)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{dump_mathml(self)}\" #{parameters[:name]}\n"]
          mathml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr })
          mathml_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr })
          mathml_fields_to_print(parameter_three, { spacing: new_spacing, field_name: parameters[:third_value], additional_space: "   |_ ", array: new_arr })
          new_arr
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:)
          parameters = self.class::FUNCTION
          new_spacing = gsub_spacing(spacing, last)
          new_arr = ["#{spacing}\"#{dump_omml(self, display_style)}\" #{parameters[:name]}\n"]
          omml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: parameters[:first_value], additional_space: "|  |_ ", array: new_arr, display_style: display_style })
          omml_fields_to_print(parameter_two, { spacing: new_spacing, field_name: parameters[:second_value], additional_space: "  |_ ", array: new_arr, display_style: display_style })
          omml_fields_to_print(parameter_three, { spacing: new_spacing, field_name: parameters[:third_value], additional_space: "   |_ ", array: new_arr, display_style: display_style })
          new_arr
        end

        def any_value_exist?
          !(parameter_one.nil? || parameter_two.nil? || parameter_three.nil?)
        end

        protected

        def latex_wrapped(field)
          if field.validate_function_formula
            "{ \\left ( #{field.to_latex} \\right ) }"
          else
            "{#{field.to_latex}}"
          end
        end

        def gsub_spacing(spacing, last)
          spacing.gsub(/\|\_/, last ? "  " : "| ")
        end

        def invert_unicode_symbols
          Mathml::Constants::UNICODE_SYMBOLS.invert[class_name] || class_name
        end

        def wrapped(field, type: "ascii")
          return "" unless field

          type == "ascii" ? "(#{field.to_asciimath})" : "{#{field.to_latex}}"
        end

        def first_field_wrap(field, type: "ascii")
          return "" unless field

          type == "ascii" ? ascii_wrap(field) : latex_wrap(field)
        end

        def ascii_wrap(field)
          asciimath = field.to_asciimath
          return latex if ["obrace", "ubrace"].include?(field.class_name)

          case field
          when Formula || field.class.name.include?("Function")
            "(#{asciimath})"
          else
            asciimath
          end
        end

        def latex_wrap(field)
          latex = field.to_latex
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

        def validate_mathml_tag(parameter)
          return Array(Utility.ox_element("mrow")) unless parameter

          Array(parameter.to_mathml_without_math_tag)
        end

        def underover(display_style)
          overset = Overset.new(parameter_one, parameter_three)
          return overset.to_omml_without_math_tag(display_style) unless parameter_two

          Underset.new(overset, parameter_two)&.to_omml_without_math_tag(display_style)
        end
      end
    end
  end
end
