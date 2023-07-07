# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class PowerBase < TernaryFunction
        def to_mathml_without_math_tag
          tag_name = (underover_class?(parameter_one) ? "underover" : "subsup")
          subsup_tag = Utility.ox_element("m#{tag_name}")
          new_arr = []
          new_arr << parameter_one.to_mathml_without_math_tag
          new_arr << parameter_two&.to_mathml_without_math_tag
          new_arr << parameter_three&.to_mathml_without_math_tag
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
            sub_parameter,
            sup_parameter,
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
              e_parameter,
              sub_parameter,
              sup_parameter,
            ],
          )
          [ssubsup]
        end

        protected

        def sub_parameter
          sub_tag = Utility.ox_element("sub", namespace: "m")
          return empty_tag(sub_tag) unless parameter_two

          Utility.update_nodes(sub_tag, insert_t_tag(parameter_two))
        end

        def sup_parameter
          sup_tag = Utility.ox_element("sup", namespace: "m")
          return empty_tag(sup_tag) unless parameter_three

          Utility.update_nodes(sup_tag, insert_t_tag(parameter_three))
        end

        def e_parameter
          e_tag = Utility.ox_element("e", namespace: "m")
          return empty_tag(e_tag) unless parameter_one

          Utility.update_nodes(e_tag, insert_t_tag(parameter_one))
        end

        def empty_tag(wrapper_tag)
          r_tag = Utility.ox_element("r", namespace: "m")
          r_tag << (Utility.ox_element("t", namespace: "m") << "&#8203;")
          wrapper_tag << r_tag
        end

        def insert_t_tag(parameter)
          parameter_value = parameter&.to_omml_without_math_tag
          r_tag = Utility.ox_element("r", namespace: "m")
          if parameter.is_a?(Symbol)
            r_tag << (Utility.ox_element("t", namespace: "m") << parameter_value)
            [r_tag]
          elsif parameter.is_a?(Number)
            Utility.update_nodes(r_tag, parameter_value)
            [r_tag]
          else
            Array(parameter_value)
          end
        end

        def chr_value(narypr)
          first_value = Utility.html_entity_to_unicode(parameter_one&.nary_attr_value)
          return narypr if first_value == "∫"

          narypr << Utility.ox_element(
            "chr",
            namespace: "m",
            attributes: { "m:val": first_value },
          )
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
