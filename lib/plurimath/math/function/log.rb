# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Log < BinaryFunction
        FUNCTION = {
          name: "function apply",
          first_value: "subscript",
          second_value: "supscript",
        }

        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "log#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_#{latex_wrapped(parameter_one)}" if parameter_one
          second_value = "^#{latex_wrapped(parameter_two)}" if parameter_two
          "\\log#{first_value}#{second_value}"
        end

        def to_html
          first_value = "<sub>#{parameter_one.to_html}</sub>" if parameter_one
          second_value = "<sup>#{parameter_two.to_html}</sup>" if parameter_two
          "<i>log</i>#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag(display_style)
          return r_element("log", rpr_tag: false) unless all_values_exist?

          ssubsup   = Utility.ox_element("sSubSup", namespace: "m")
          ssubsuppr = Utility.ox_element("sSubSupPr", namespace: "m")
          ssubsuppr << hide_tags(
            Utility.pr_element("ctrl", true, namespace: "m"),
          )
          Utility.update_nodes(
            ssubsup,
            [
              ssubsuppr,
              e_parameter,
              omml_parameter(parameter_one, display_style, tag_name: "sub"),
              omml_parameter(parameter_two, display_style, tag_name: "sup"),
            ],
          )
          [ssubsup]
        end

        def to_mathml_without_math_tag
          subsup_tag = Utility.ox_element("msubsup")
          first_value = (Utility.ox_element("mi") << "log")
          if parameter_one || parameter_two
            new_arr = [first_value]
            new_arr << parameter_one&.to_mathml_without_math_tag
            new_arr << parameter_two&.to_mathml_without_math_tag
            Utility.update_nodes(
              subsup_tag,
              new_arr,
            )
          else
            first_value
          end
        end

        protected

        def e_parameter
          e_tag = Utility.ox_element("e", namespace: "m")
          e_tag << rpr_tag
        end

        def hide_tags(nar)
          attr = { "m:val": "1" }
          if parameter_one.nil?
            nar << Utility.ox_element(
              "subHide",
              namespace: "m",
              attributes: attr,
            )
          end
          if parameter_two.nil?
            nar << Utility.ox_element(
              "supHide",
              namespace: "m",
              attributes: attr,
            )
          end
          nar
        end

        def rpr_tag
          sty_atrs = { "m:val": "p" }
          sty_tag  = Utility.ox_element("sty", attributes: sty_atrs, namespace: "m")
          rpr_tag  = (Utility.ox_element("rPr", namespace: "m") << sty_tag)
          r_tag = Utility.ox_element("r", namespace: "m")
          t_tag = (Utility.ox_element("t", namespace: "m") << "log")
          Utility.update_nodes(r_tag, [rpr_tag, t_tag])
        end
      end
    end
  end
end
