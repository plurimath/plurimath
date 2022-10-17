# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class PowerBase < TernaryFunction
        def to_mathml_without_math_tag
          first_value  = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          third_value  = parameter_three&.to_mathml_without_math_tag
          "<msubsup>#{first_value}#{second_value}#{third_value}</msubsup>"
        end

        def to_latex
          first_value  = parameter_one&.to_latex
          second_value = parameter_two&.to_latex
          third_value  = parameter_three&.to_latex
          first_value  = "{#{first_value}}" if parameter_one.is_a?(Formula)
          "#{first_value}_{#{second_value}}^{#{third_value}}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>"
          second_value = "<sub>#{parameter_two.to_html}</sub>"
          third_value  = "<sup>#{parameter_three.to_html}</sup>"
          "#{first_value}#{second_value}#{third_value}"
        end

        def omml_nary_tag
          narypr = Utility.omml_element("m:naryPr")
          chr_value(narypr)
          narypr << Utility.omml_element("m:limLoc", { "m:val": "subSup" })
          hide_tags(narypr)
          narypr << Utility.pr_element("m:ctrl", true)
          [
            narypr,
            sub_element,
            sup_element,
          ]
        end

        def chr_value(narypr)
          first_value = parameter_one.to_omml_without_math_tag
          return narypr if first_value == "∫"

          narypr << Utility.omml_element("m:chr", { "m:val": first_value })
        end

        def to_omml_without_math_tag
          ssubsup   = Utility.omml_element("m:sSubSup")
          ssubsuppr = Utility.omml_element("m:sSubSupPr")
          ssubsuppr << hide_tags(Utility.pr_element("m:ctrl", true))
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

        def e_element
          elemnet = Utility.omml_element("m:e")
          if parameter_one
            elemnet << parameter_one&.to_omml_without_math_tag
          else
            elemnet
          end
        end

        def sub_element
          elemnet = Utility.omml_element("m:sub")
          if parameter_two
            elemnet << parameter_two&.to_omml_without_math_tag
          else
            elemnet
          end
        end

        def sup_element
          elemnet = Utility.omml_element("m:sup")
          if parameter_three
            elemnet << parameter_three&.to_omml_without_math_tag
          else
            elemnet
          end
        end

        def hide_tags(nar)
          attr = { "m:val": "1" }
          nar << Utility.omml_element("m:subHide", attr) if parameter_two.nil?
          nar << Utility.omml_element("m:supHide", attr) if parameter_three.nil?
          nar
        end
      end
    end
  end
end
