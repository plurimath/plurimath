# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Fenced < TernaryFunction
        attr_accessor :options

        def initialize(
              parameter_one = nil,
              parameter_two = nil,
              parameter_three = nil,
              options = {})
          super(parameter_one, parameter_two, parameter_three)
          @options = options
        end

        def to_asciimath
          first_value  = parameter_one ? parameter_one.to_asciimath : "("
          third_value  = parameter_three ? parameter_three.to_asciimath : ")"
          "#{first_value}#{parameter_two&.map(&:to_asciimath)&.join(' ')}#{third_value}"
        end

        def to_mathml_without_math_tag
          first_value = Utility.ox_element("mo", attributes: options&.dig(:open_paren)) << (mathml_paren(parameter_one) || "")
          second_value = parameter_two&.map(&:to_mathml_without_math_tag) || []
          third_value = Utility.ox_element("mo", attributes: options&.dig(:close_paren)) << (mathml_paren(parameter_three) || "")
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
          fenced_value = parameter_two&.map(&:to_latex)&.join(" ")
          first_value  = latex_paren(parameter_one&.value)
          second_value = latex_paren(parameter_three&.value)
          "#{first_value} #{fenced_value} #{second_value}"
        end

        def to_omml_without_math_tag(display_style)
          attrs = { "m:val": (options ? options[:separators] : "") }
          d = Utility.ox_element("d", namespace: "m")
          dpr = Utility.ox_element("dPr", namespace: "m")
          open_paren(dpr)
          dpr << Utility.ox_element("sepChr", namespace: "m", attributes: attrs)
          close_paren(dpr)
          Utility.update_nodes(
            d,
            [
              dpr,
              omml_parameter(
                Formula.new(Array(parameter_two)),
                display_style,
                tag_name: "e",
              ),
            ],
          )
          [d]
        end

        def to_asciimath_math_zone(spacing, last = false, indent = true)
          filtered_values(parameter_two).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_asciimath_math_zone(spacing, last, indent)
          end
        end

        def to_latex_math_zone(spacing, last = false, indent = true)
          filtered_values(parameter_two).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_latex_math_zone(spacing, last, indent)
          end
        end

        def to_mathml_math_zone(spacing, last = false, indent = true)
          filtered_values(parameter_two).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_mathml_math_zone(spacing, last, indent)
          end
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:)
          filtered_values(parameter_two).map do |object|
            object.to_omml_math_zone(spacing, last, !indent, display_style: display_style)
          end
        end

        def line_breaking(obj)
          field_values = result(Array(parameter_two))
          return unless field_values.length > 1

          obj.update(value_split(obj, field_values))
        end

        protected

        def open_paren(dpr)
          first_value = parameter_one&.value
          return dpr if first_value.nil? || first_value.empty?

          attributes = { "m:val": first_value }
          dpr << Utility.ox_element(
            "begChr",
            namespace: "m",
            attributes: attributes,
          )
        end

        def close_paren(dpr)
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
          return paren.gsub(":", "") if paren.include?(":") && ["{:", ":}"].include?(paren)

          paren = %w[{ }].include?(paren) ? "\\#{paren}" : paren
          paren = "\\#{Latex::Constants::UNICODE_SYMBOLS.invert[paren]}" if paren&.to_s&.match?(/&#x.{0,4};/)
          paren&.to_s
        end

        def mathml_paren(field)
          unicodemath_syntax = ["&#x3016;", "&#x3017;"]
          return "" if field&.value&.include?(":") || unicodemath_syntax.include?(field&.value&.to_s)

          field&.value
        end

        def value_split(obj, field_value)
          object = cloned_objects
          breaked_result = field_value.first.last.omml_line_break(field_value)
          self.parameter_two = Array(breaked_result.shift)
          object.parameter_one = nil
          object.parameter_two = breaked_result.flatten
          self.parameter_three = nil
          object
        end
      end
    end
  end
end
