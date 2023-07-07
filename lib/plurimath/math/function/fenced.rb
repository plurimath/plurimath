# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Fenced < TernaryFunction
        def to_asciimath
          first_value  = parameter_one ? parameter_one.to_asciimath : "("
          third_value  = parameter_three ? parameter_three.to_asciimath : ")"
          "#{first_value}#{parameter_two&.map(&:to_asciimath)&.join(' ')}#{third_value}"
        end

        def to_mathml_without_math_tag
          first_value = Utility.ox_element("mo") << (mathml_paren(parameter_one) || "")
          second_value = parameter_two&.map(&:to_mathml_without_math_tag) || []
          third_value = Utility.ox_element("mo") << (mathml_paren(parameter_three) || "")
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            (second_value.insert(0, first_value) << third_value),
          )
        end

        def to_html
          first_value  = "<i>#{parameter_one.value}</i>" if parameter_one
          second_value = parameter_two.map(&:to_html).join if parameter_two
          third_value  = "<i>#{parameter_three.value}</i>" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_latex
          open_paren   = parameter_one ? parameter_one.value : "("
          fenced_value = parameter_two&.map(&:to_latex)&.join(" ")
          close_paren  = parameter_three ? parameter_three.value : ")"
          first_value  = latex_paren(open_paren)
          second_value = latex_paren(close_paren)
          "#{first_value} #{fenced_value} #{second_value}"
        end

        def to_omml_without_math_tag
          d = Utility.ox_element("d", namespace: "m")
          dpr = Utility.ox_element("dPr", namespace: "m")
          first_value(dpr)
          third_value(dpr)
          dpr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            d,
            [dpr, second_value],
          )
          [d]
        end

        protected

        def first_value(dpr)
          first_value = parameter_one&.value
          return dpr if first_value.nil? || first_value.empty?

          attributes = { "m:val": first_value }
          dpr << Utility.ox_element(
            "begChr",
            namespace: "m",
            attributes: attributes,
          )
        end

        def second_value
          class_names = ["number", "symbol"].freeze
          e_tag = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(
            e_tag,
            Formula.new(parameter_two).to_omml_without_math_tag,
          )
          e_tag
        end

        def third_value(dpr)
          third_value = parameter_three&.value
          return dpr if third_value.nil? || third_value.empty?

          attributes = { "m:val": third_value }
          dpr << Utility.ox_element(
            "endChr",
            namespace: "m",
            attributes: attributes,
          )
        end

        def latex_paren(paren)
          return "" if paren.nil? || paren.empty?

          paren = %w[{ }].include?(paren) ? "\\#{paren}" : paren
          paren = "\\#{Latex::Constants::UNICODE_SYMBOLS.invert[paren]}" if paren.to_s.match?(/\&#x.{0,4};/)
          paren.to_s
        end

        def mathml_paren(field)
          return "" if field&.value&.include?(":")

          field&.value
        end
      end
    end
  end
end
