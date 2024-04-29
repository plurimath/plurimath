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

        def ==(object)
          super(object) &&
            object.options == options
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
          first_value  = "<i>#{symbol_or_paren(parameter_one, lang: :html)}</i>" if parameter_one
          second_value = parameter_two.map(&:to_html).join if parameter_two
          third_value  = "<i>#{symbol_or_paren(parameter_three, lang: :html)}</i>" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_latex
          fenced_value = parameter_two&.map(&:to_latex)&.join(" ")
          first_value  = latex_paren(symbol_or_paren(parameter_one, lang: :latex))
          second_value = latex_paren(symbol_or_paren(parameter_three, lang: :latex))
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

        def to_unicodemath
          return mini_sized_unicode if mini_sized?

          fenced_value = parameter_two&.map do |param|
            next param.choose_frac if choose_frac?(param)

            param.to_unicodemath
          end&.join(" ")
          return fenced_value if choose_frac?(parameter_two.first)

          fenced_value = "(#{fenced_value})" if vert_paren?

          "#{unicode_open_paren}#{fenced_value}#{unicode_close_paren}"
        end

        def to_asciimath_math_zone(spacing, last = false, indent = true)
          filtered_values(parameter_two, lang: :asciimath).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_asciimath_math_zone(spacing, last, indent)
          end
        end

        def to_latex_math_zone(spacing, last = false, indent = true)
          filtered_values(parameter_two, lang: :latex).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_latex_math_zone(spacing, last, indent)
          end
        end

        def to_mathml_math_zone(spacing, last = false, indent = true)
          filtered_values(parameter_two, lang: :mathml).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_mathml_math_zone(spacing, last, indent)
          end
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:)
          filtered_values(parameter_two, lang: :omml).map do |object|
            object.to_omml_math_zone(spacing, last, !indent, display_style: display_style)
          end
        end

        def line_breaking(obj)
          field_values = result(Array(parameter_two))
          return unless field_values.length > 1

          obj.update(value_split(obj, field_values))
        end

        def mini_sized?
          parameter_one&.mini_sized? ||
            Math::Formula.new(parameter_two)&.mini_sized? ||
            parameter_three&.mini_sized?
        end

        def mini_sized_unicode
          fenced_value = parameter_two&.map(&:to_unicodemath)&.join
          "#{parameter_one.to_unicodemath}#{fenced_value}#{parameter_three.to_unicodemath}"
        end

        protected

        def open_paren(dpr)
          first_value = symbol_or_paren(parameter_one, lang: :omml)
          return dpr if first_value.nil?

          attributes = { "m:val": Utility.html_entity_to_unicode(first_value) }
          dpr << Utility.ox_element(
            "begChr",
            namespace: "m",
            attributes: attributes,
          )
        end

        def close_paren(dpr)
          third_value = symbol_or_paren(parameter_three, lang: :omml)
          return dpr if third_value.nil?

          attributes = { "m:val": Utility.html_entity_to_unicode(third_value) }
          dpr << Utility.ox_element(
            "endChr",
            namespace: "m",
            attributes: attributes,
          )
        end

        def latex_paren(paren)
          return "" if paren.nil?
          return paren.gsub(":", "") if paren.include?(":") && ["{:", ":}"].include?(paren)

          paren
        end

        def mathml_paren(field)
          unicodemath_syntax = ["&#x3016;", "&#x3017;", "&#x2524;", "&#x251c;"]
          paren = symbol_or_paren(field, lang: :mathml)
          (paren&.include?(":") || unicodemath_syntax.include?(paren)) ? "" : paren
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

        def unicode_open_paren
          paren = parameter_one&.to_unicodemath
          return "├#{convert_paren_size(paren_size: options&.dig(:open_paren, :minsize))}#{paren}" if options&.key?(:open_paren)
          return "├#{paren}" if options&.key?(:open_prefixed) && !open_or_begin?
          return "├" if options&.key?(:open_prefixed) || paren == "{:"

          paren
        end

        def unicode_close_paren
          paren = parameter_three&.to_unicodemath
          return "┤#{convert_paren_size(paren_size: options&.dig(:close_paren, :minsize))}#{paren}" if options&.key?(:close_paren)
          return "┤#{paren}" if options&.key?(:close_prefixed) && !close_or_end?
          return "┤" if options&.key?(:close_prefixed) || paren == ":}"

          paren
        end

        def choose_frac?(param)
          param&.is_a?(Math::Function::Frac) && param&.options&.key?(:choose)
        end

        def convert_paren_size(paren_size:)
          paren = paren_size.delete_suffix("em").to_f
          (::Math.log(paren) / ::Math.log(1.25)).round
        end

        def open_or_begin?
          parameter_one&.value&.include?("&#x251c;") ||
            parameter_one&.value&.include?("&#x3016;") ||
            parameter_one&.value&.include?("{:")
        end

        def close_or_end?
          parameter_three&.value&.include?("&#x2524;") ||
            parameter_three&.value&.include?("&#x3017;") ||
            parameter_three&.value&.include?(":}")
        end

        def vert_paren?
          return parameter_one&.value&.include?("|") if parameter_one.class_name == "symbol"

          parameter_one.is_a?(Math::Symbols::Paren::Vert)
        end

        def symbol_or_paren(field, lang:)
          return field&.value unless field.is_a?(Math::Symbols::Paren)

          case lang
          when :mathml, :html
            field.to_mathml_without_math_tag.nodes.first
          when :latex
            field.to_latex
          when :omml
            field.to_omml_without_math_tag(true)
          end
        end
      end
    end
  end
end
