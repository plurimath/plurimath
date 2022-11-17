# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Fenced < TernaryFunction
        def to_asciimath
          first_value  = parameter_one ? parameter_one.to_asciimath : "("
          second_value = parameter_two&.map(&:to_asciimath)&.join(",")
          third_value  = parameter_three ? parameter_three.to_asciimath : ")"
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag
          first_value  = parameter_one&.value
          second_value = parameter_two&.map(&:to_mathml_without_math_tag)
          third_value  = parameter_three&.value
          Utility.update_nodes(
            Utility.omml_element(
              "mfenced",
              attributes: { open: first_value, close: third_value },
            ),
            second_value,
          )
        end

        def to_omml_without_math_tag
          d = Utility.omml_element("d", namespace: "m")
          dpr = Utility.omml_element("dPr", namespace: "m")
          first_value(dpr)
          third_value(dpr)
          dpr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            d,
            [dpr] + second_value,
          )
        end

        def second_value
          class_names = ["number", "symbol"].freeze
          parameter_two.map do |object|
            e_tag = Utility.omml_element("e", namespace: "m")
            e_tag << if class_names.include?(object.class_name)
                       fenced_omml_value(object)
                     else
                       object.to_omml_without_math_tag
                     end
          end
        end

        def fenced_omml_value(object)
          r_tag = Utility.omml_element("r", namespace: "m")
          t_tag = Utility.omml_element("t", namespace: "m")
          t_tag << object.value
          r_tag << t_tag
        end

        def first_value(dpr)
          first_value = parameter_one&.value
          return dpr if first_value.nil? || first_value.empty?

          attributes = { "m:val": first_value }
          dpr << Utility.omml_element(
            "begChr",
            namespace: "m",
            attributes: attributes,
          )
        end

        def third_value(dpr)
          third_value = parameter_three&.value
          return dpr if third_value.nil? || third_value.empty?

          attributes = { "m:val": third_value }
          dpr << Utility.omml_element(
            "endChr",
            namespace: "m",
            attributes: attributes,
          )
        end
      end
    end
  end
end
