# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class UnaryFunction
        # Display-tree writers load only when their public entrypoints are used.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing, last = false, _, options:)
            new_spacing = gsub_spacing(spacing, last)
            new_arr = [
              "#{spacing}\"#{to_asciimath(options: options)}\" function apply\n",
              "#{new_spacing}|_ \"#{class_name}\" function name\n",
            ]
            ascii_fields_to_print(parameter_one,
                                  { spacing: new_spacing, field_name: "argument", additional_space: "   |_ ",
                                    array: new_arr, options: options })
            new_arr
          end

          def to_latex_math_zone(spacing, last = false, _, options:)
            new_spacing = gsub_spacing(spacing, last)
            new_arr = [
              "#{spacing}\"#{to_latex(options: options)}\" function apply\n",
              "#{new_spacing}|_ \"#{class_name}\" function name\n",
            ]
            latex_fields_to_print(parameter_one,
                                  { spacing: new_spacing, field_name: "argument", additional_space: "   |_ ",
                                    array: new_arr, options: options })
            new_arr
          end

          def to_mathml_math_zone(spacing, last = false, _, options:)
            new_spacing = gsub_spacing(spacing, last)
            new_arr = [
              "#{spacing}\"#{dump_mathml(self,
                                         options: options)}\" function apply\n",
              "#{new_spacing}|_ \"#{class_name}\" function name\n",
            ]
            mathml_fields_to_print(parameter_one,
                                   { spacing: new_spacing, field_name: "argument", additional_space: "   |_ ",
                                     array: new_arr, options: options })
            new_arr
          end

          def to_omml_math_zone(spacing, last = false, _, display_style:,
            options:)
            new_spacing = gsub_spacing(spacing, last)
            new_arr = [
              "#{spacing}\"#{dump_omml(self, display_style,
                                       options: options)}\" function apply\n",
              "#{new_spacing}|_ \"#{class_name}\" function name\n",
            ]
            omml_fields_to_print(parameter_one,
                                 { spacing: new_spacing, field_name: "argument", additional_space: "   |_ ",
                                   array: new_arr, display_style: display_style, options: options })
            new_arr
          end

          def to_unicodemath_math_zone(spacing, last = false, _, options:)
            new_spacing = gsub_spacing(spacing, last)
            new_arr = [
              "#{spacing}\"#{to_unicodemath(options: options)}\" function apply\n",
              "#{new_spacing}|_ \"#{class_name}\" function name\n",
            ]
            unicodemath_fields_to_print(parameter_one,
                                        { spacing: new_spacing, field_name: "argument", additional_space: "   |_ ",
                                          array: new_arr, options: options })
            new_arr
          end
        end
      end
    end
  end
end
