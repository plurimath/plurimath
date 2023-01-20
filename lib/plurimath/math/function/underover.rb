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

        def to_omml_without_math_tag
          limupp = Utility.ox_element("limUpp", namespace: "m")
          limpr = Utility.ox_element("limUppPr", namespace: "m")
          limpr << Utility.pr_element("ctrl", namespace: "m")
          e_tag = Utility.ox_element("e", namespace: "m")
          e_tag << parameter_one&.to_omml_without_math_tag
          lim = Utility.ox_element("lim", namespace: "m")
          lim << parameter_two&.to_omml_without_math_tag if parameter_two
          Utility.update_nodes(
            limupp,
            [
              e_tag,
              lim,
            ],
          )
        end

        def omml_nary_tag
          pr = Utility.ox_element("naryPr", namespace: "m")
          [pr_element_value(pr), sub_value, sup_value]
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

        def sub_value
          sub = Utility.ox_element("sub", namespace: "m")
          sub << omml_value(parameter_two) if parameter_two
          sub
        end

        def sup_value
          sup = Utility.ox_element("sup", namespace: "m")
          sup << omml_value(parameter_three) if parameter_three
          sup
        end

        def first_value(pr_element)
          first_value = parameter_one.is_a?(Number) ? parameter_one.value : parameter_one.to_omml_without_math_tag
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
