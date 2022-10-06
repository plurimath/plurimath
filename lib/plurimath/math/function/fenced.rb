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
          second_value = parameter_two&.map(&:to_mathml_without_math_tag)&.join
          third_value  = parameter_three&.value
          "<mfenced open='#{first_value}' close='#{third_value}'>"\
            "#{second_value}"\
            "</mfenced>"
        end

        def to_omml_without_math_tag
          d = Utility.omml_element("m:d")
          dpr = Utility.omml_element("m:dPr")
          first_value(dpr)
          third_value(dpr)
          dpr << Utility.pr_element("m:ctrl", true)
          Utility.update_nodes(
            d,
            [dpr] + second_value,
          )
        end

        def second_value
          class_names = ["number", "symbol"].freeze
          parameter_two.map do |object|
            e_tag = Utility.omml_element("m:e")
            if class_names.include?(object.class_name)
              e_tag << fenced_omml_value(object)
            else
              e_tag << object.to_omml_without_math_tag
            end
          end
        end

        def fenced_omml_value(object)
          <<~OMML
            <m:r>
              <m:t>#{object.value}</m:t>
            </m:r>
          OMML
        end

        def first_value(dpr)
          first_value = parameter_one&.value
          return dpr if first_value.nil? || first_value.empty?

          dpr << Utility.omml_element("m:begChr", { "m:val": first_value })
        end

        def third_value(dpr)
          third_value = parameter_three&.value
          return dpr if third_value.nil? || third_value.empty?

          dpr << Utility.omml_element("m:endChr", { "m:val": third_value })
        end
      end
    end
  end
end
