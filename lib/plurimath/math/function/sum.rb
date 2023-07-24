# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Sum < TernaryFunction
        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "sum#{first_value}#{second_value} #{parameter_three&.to_asciimath}".strip
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\sum#{first_value}#{second_value} #{parameter_three&.to_latex}".strip
        end

        def to_mathml_without_math_tag
          first_value = Utility.ox_element("mo") << invert_unicode_symbols.to_s
          if parameter_one || parameter_two
            value_array = []
            value_array << parameter_one&.to_mathml_without_math_tag
            value_array << parameter_two&.to_mathml_without_math_tag
            tag_name = if parameter_two && parameter_one
                         "underover"
                       else
                         parameter_one ? "under" : "over"
                       end
            munderover_tag = Utility.ox_element("m#{tag_name}")
            Utility.update_nodes(
              munderover_tag,
              value_array.insert(0, first_value),
            )
            return munderover_tag if parameter_three.nil?

            Utility.update_nodes(
              Utility.ox_element("mrow"),
              [
                munderover_tag,
                parameter_three&.to_mathml_without_math_tag,
              ].flatten.compact,
            )
          else
            first_value
          end
        end

        def to_html
          first_value = "<sub>#{parameter_one.to_html}</sub>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html}</sup>" if parameter_two
          "<i>&sum;</i>#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag
          if all_values_exist?
            nary = Utility.ox_element("nary", namespace: "m")
            Utility.update_nodes(
              nary,
              [
                narypr("∑"),
                omml_parameter(parameter_one, tag_name: "sub"),
                omml_parameter(parameter_two, tag_name: "sup"),
                omml_parameter(parameter_three, tag_name: "e"),
              ],
            )
            [nary]
          else
            r_tag = Utility.ox_element("r", namespace: "m")
            t_tag = Utility.ox_element("t", namespace: "m")
            r_tag << (t_tag << "&#x2211;")
            [r_tag]
          end
        end
      end
    end
  end
end
