# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Underover < TernaryFunction
        def to_asciimath
          first_value = first_field_wrap(parameter_one) if parameter_one
          second_value = "_#{wrapped(parameter_two)}" if parameter_two
          third_value = "^#{wrapped(parameter_three)}" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_latex
          first_value = first_field_wrap(parameter_one, type: "latex") if parameter_one
          second_value = "_#{wrapped(parameter_two, type: 'latex')}" if parameter_two
          third_value = "^#{wrapped(parameter_three, type: 'latex')}" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag
          first_value  = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          third_value  = parameter_three&.to_mathml_without_math_tag
          class_tag = Utility.ox_element("m#{class_name}")
          Utility.update_nodes(
            class_tag,
            [
              first_value,
              second_value,
              third_value,
            ],
          )
        end

        def to_omml_without_math_tag(display_style)
          if !display_style
            power_base = PowerBase.new(parameter_one, parameter_two, parameter_three)
            return power_base.to_omml_without_math_tag(display_style)
          end

          underover(display_style)
        end

        def omml_nary_tag(display_style)
          pr = Utility.ox_element("naryPr", namespace: "m")
          [
            pr_element_value(pr),
            omml_parameter(parameter_two, display_style, tag_name: "sub"),
            omml_parameter(parameter_three, display_style, tag_name: "sup"),
          ]
        end

        protected

        def hidden_sub_tag(pr_element)
          return true unless parameter_two.nil?

          pr_element << Utility.ox_element(
            "subHide",
            namespace: "m",
            attributes: { "m:val": 1 },
          )
        end

        def hidden_sup_tag(pr_element)
          return true unless parameter_three.nil?

          pr_element << Utility.ox_element(
            "supHide",
            namespace: "m",
            attributes: { "m:val": 1 },
          )
        end

        def pr_element_value(pr_element)
          first_value(pr_element)
          pr_element << Utility.ox_element(
            "limLoc",
            namespace: "m",
            attributes: { "m:val": "undOvr" },
          )
          hidden_sub_tag(pr_element)
          hidden_sup_tag(pr_element)
          pr_element << Utility.pr_element("ctrl", true, namespace: "m")
        end

        def first_value(pr_element)
          first_value = parameter_one.nary_attr_value
          first_value = Utility.html_entity_to_unicode(first_value)
          unless first_value == "∫"
            pr_element << Utility.ox_element(
              "chr",
              namespace: "m",
              attributes: { "m:val": first_value },
            )
          end
        end
      end
    end
  end
end
