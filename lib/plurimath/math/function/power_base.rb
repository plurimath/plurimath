# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class PowerBase < TernaryFunction
        def to_mathml_without_math_tag
          tag_name = (["ubrace", "obrace"].include?(parameter_one&.class_name) ? "underover" : "subsup")
          subsup_tag = Utility.ox_element("m#{tag_name}")
          new_arr = []
          new_arr << parameter_one.to_mathml_without_math_tag
          new_arr << parameter_two&.to_mathml_without_math_tag
          new_arr << parameter_three&.to_mathml_without_math_tag
          Utility.update_nodes(
            subsup_tag,
            new_arr,
          )
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

        def omml_nary_tag
          narypr = Utility.ox_element("naryPr", namespace: "m")
          chr_value(narypr)
          narypr << Utility.ox_element(
            "limLoc",
            namespace: "m",
            attributes: { "m:val": "subSup" },
          )
          hide_tags(narypr)
          narypr << Utility.pr_element("ctrl", true, namespace: "m")
          [
            narypr,
            sub_element,
            sup_element,
          ]
        end

        def to_omml_without_math_tag
          ssubsup   = Utility.ox_element("sSubSup", namespace: "m")
          ssubsuppr = Utility.ox_element("sSubSupPr", namespace: "m")
          ssubsuppr << hide_tags(
            Utility.pr_element("ctrl", true, namespace: "m"),
          )
          Utility.update_nodes(
            ssubsup,
            [
              ssubsuppr,
              e_element,
              sub_element,
              sup_element,
            ],
          )
        end

        protected

        def chr_value(narypr)
          first_value = parameter_one.to_omml_without_math_tag
          return narypr if first_value == "∫"

          narypr << Utility.ox_element(
            "chr",
            namespace: "m",
            attributes: { "m:val": first_value },
          )
        end

        def e_element
          elemnet = Utility.ox_element("e", namespace: "m")
          if parameter_one
            elemnet << parameter_one&.to_omml_without_math_tag
          else
            elemnet
          end
        end

        def sub_element
          elemnet = Utility.ox_element("sub", namespace: "m")
          if parameter_two
            elemnet << parameter_two&.to_omml_without_math_tag
          else
            elemnet
          end
        end

        def sup_element
          elemnet = Utility.ox_element("sup", namespace: "m")
          if parameter_three
            elemnet << parameter_three&.to_omml_without_math_tag
          else
            elemnet
          end
        end

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
