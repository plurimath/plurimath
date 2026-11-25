# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Vec
        # Specialized tree writers load on first display use.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing, last = false, _, options:)
            new_spacing = gsub_spacing(spacing, last)
            new_arr = [
              "#{spacing}\"#{to_asciimath(options: options)}\" function apply\n",
              "#{new_spacing}|_ \"#{class_name}\" function name\n",
            ]
            ascii_fields_to_print(parameter_one,
                                  { spacing: new_spacing, field_name: "supscript", additional_space: "|  |_ ",
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
                                  { spacing: new_spacing, field_name: "supscript", additional_space: "|  |_ ",
                                    array: new_arr, options: options })
            new_arr
          end

          def to_mathml_math_zone(spacing, last = false, _, options:)
            new_spacing = gsub_spacing(spacing, last)
            new_arr = [
              "#{spacing}\"#{dump_mathml(self, options: options)}\" overset\n",
              "#{new_spacing}|_ \"<mo>&#x2192;</mo>\" base\n",
            ]
            mathml_fields_to_print(parameter_one,
                                   { spacing: new_spacing, field_name: "supscript", additional_space: "|  |_ ",
                                     array: new_arr, options: options })
            new_arr
          end

          def to_omml_math_zone(spacing, last = false, _, display_style:,
  options:)
            new_spacing = gsub_spacing(spacing, last)
            new_arr = [
              "#{spacing}\"#{dump_omml(self, display_style,
                                       options: options)}\" overset\n",
              "#{new_spacing}|_ \"<m:t>&#x2192;</m:t>\" base\n",
            ]
            omml_fields_to_print(parameter_one,
                                 { spacing: new_spacing, field_name: "supscript", additional_space: "|  |_ ",
                                   array: new_arr, display_style: display_style, options: options })
            new_arr
          end
        end
      end
    end
  end
end
