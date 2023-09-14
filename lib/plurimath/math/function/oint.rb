# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Oint < TernaryFunction
        FUNCTION = {
          name: "contour integral",
          first_value: "subscript",
          second_value: "supscript",
        }

        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "oint#{first_value}#{second_value} #{parameter_three&.to_asciimath}".strip
        end

        def to_latex
          first_value = "_#{latex_wrapped(parameter_one)}" if parameter_one
          second_value = "^#{latex_wrapped(parameter_two)}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value} #{parameter_three&.to_latex}".strip
        end

        def to_mathml_without_math_tag
          mo_tag = Utility.ox_element("mo") << invert_unicode_symbols.to_s
          return mo_tag unless all_values_exist?

          value_array = [mo_tag]
          value_array << parameter_one&.to_mathml_without_math_tag
          value_array << parameter_two&.to_mathml_without_math_tag
          tag_name = if parameter_one && parameter_two
                       "subsup"
                     else
                       parameter_one ? "sub" : "sup"
                     end
          msubsup_tag = Utility.ox_element("m#{tag_name}")
          Utility.update_nodes(msubsup_tag, value_array)
          return msubsup_tag if parameter_three.nil?

          Utility.update_nodes(
            Utility.ox_element("mrow"),
            [
              msubsup_tag,
              parameter_three&.to_mathml_without_math_tag,
            ].compact,
          )
        end

        def to_omml_without_math_tag(display_style)
          if all_values_exist?
            nary = Utility.ox_element("nary", namespace: "m")
            Utility.update_nodes(
              nary,
              [
                narypr((hide_function_name ? "" : "∮"), function_type: "subSup"),
                omml_parameter(parameter_one, display_style, tag_name: "sub"),
                omml_parameter(parameter_two, display_style, tag_name: "sup"),
                omml_parameter(parameter_three, display_style, tag_name: "e"),
              ],
            )
            [nary]
          else
            r_tag = Utility.ox_element("r", namespace: "m")
            t_tag = Utility.ox_element("t", namespace: "m")
            r_tag << (t_tag << "&#x222e;")
            [r_tag]
          end
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            oint = self.class.new(Utility.filter_values(obj.value), parameter_two, parameter_three)
            oint.hide_function_name = true
            obj.update(oint)
            self.parameter_two = nil
            self.parameter_three = nil
            return
          end

          parameter_three&.line_breaking(obj)
          if obj.value_exist?
            oint = self.class.new(nil, nil, Utility.filter_values(obj.value))
            oint.hide_function_name = true
            obj.update(oint)
          end
        end
      end
    end
  end
end
