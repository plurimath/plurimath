# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class PowerBase < TernaryFunction
        FUNCTION = {
          name: "subsup",
          first_value: "base",
          second_value: "subscript",
          third_value: "supscript",
        }.freeze

        def to_mathml_without_math_tag
          subsup_tag = Utility.ox_element("m#{parameter_one.tag_name}")
          new_arr = []
          new_arr << validate_mathml_fields(parameter_one)
          new_arr << validate_mathml_fields(parameter_two)
          new_arr << validate_mathml_fields(parameter_three)
          Utility.update_nodes(subsup_tag, new_arr)
        end

        def to_latex
          first_value  = parameter_one.to_latex if parameter_one
          second_value = parameter_two.to_latex if parameter_two
          third_value  = parameter_three.to_latex if parameter_three
          "#{first_value}_{#{second_value}}^{#{third_value}}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<sub>#{parameter_two.to_html}</sub>" if parameter_two
          third_value  = "<sup>#{parameter_three.to_html}</sup>" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_omml_without_math_tag(display_style)
          return underover(display_style) if parameter_one.omml_tag_name == "undOvr"

          ssubsup   = Utility.ox_element("sSubSup", namespace: "m")
          ssubsuppr = Utility.ox_element("sSubSupPr", namespace: "m")
          ssubsuppr << hide_tags(
            Utility.pr_element("ctrl", true, namespace: "m"),
          )
          Utility.update_nodes(
            ssubsup,
            [
              ssubsuppr,
              omml_parameter(parameter_one, display_style, tag_name: "e"),
              omml_parameter(parameter_two, display_style, tag_name: "sub"),
              omml_parameter(parameter_three, display_style, tag_name: "sup"),
            ],
          )
          [ssubsup]
        end

        protected

        def hide_tags(nar)
          attr = { "m:val": "1" }
          if parameter_two.nil?
            nar << Utility.ox_element(
              "subHide",
              namespace: "m",
              attributes: attr,
            )
          end
          if parameter_three.nil?
            nar << Utility.ox_element(
              "supHide",
              namespace: "m",
              attributes: attr,
            )
          end
          nar
        end
      end
    end
  end
end
