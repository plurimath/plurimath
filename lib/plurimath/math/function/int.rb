# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Int < TernaryFunction
        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "int#{first_value}#{second_value} #{parameter_three&.to_asciimath}".strip
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value} #{parameter_three&.to_latex}".strip
        end

        def to_mathml_without_math_tag
          base_element = (Utility.ox_element("mo") << invert_unicode_symbols.to_s)
          return base_element unless all_values_exist?

          msubsup_tag = Utility.ox_element("msubsup")
          Utility.update_nodes(
            msubsup_tag,
            [
              base_element,
              validate_mathml_tag(parameter_one),
              validate_mathml_tag(parameter_two),
            ],
          )
          return msubsup_tag if parameter_three.nil?

          Utility.update_nodes(
            Utility.ox_element("mrow"),
            [
              msubsup_tag,
              parameter_three&.to_mathml_without_math_tag,
            ].flatten.compact,
          )
        end

        def to_omml_without_math_tag(display_style)
          if all_values_exist?
            nary = Utility.ox_element("nary", namespace: "m")
            Utility.update_nodes(
              nary,
              [
                narypr("∫", function_type: "subSup"),
                omml_parameter(parameter_one, display_style, tag_name: "sub"),
                omml_parameter(parameter_two, display_style, tag_name: "sup"),
                omml_parameter(parameter_three, display_style, tag_name: "e"),
              ],
            )
            [nary]
          else
            r_tag = Utility.ox_element("r", namespace: "m")
            t_tag = Utility.ox_element("t", namespace: "m")
            r_tag << (t_tag << "&#x222b;")
            [r_tag]
          end
        end
      end
    end
  end
end
