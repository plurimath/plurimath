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

        def to_mathml_without_math_tag(intent)
          first_value = ox_element("mo", attributes: options&.dig(:open_paren)) << (mathml_paren(parameter_one, intent) || "")
          third_value = ox_element("mo", attributes: options&.dig(:close_paren)) << (mathml_paren(parameter_three, intent) || "")
          mrow_value = mathml_value(intent).insert(0, first_value) << third_value
          fenced = Utility.update_nodes(ox_element("mrow"), mrow_value)
          intentify(
            fenced,
            intent,
            func_name: :interval_fence,
            intent_name: intent_value(mrow_value),
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

        def to_unicodemath_math_zone(spacing, last = false, indent = true)
          filtered_values(parameter_two, lang: :unicodemath).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_unicodemath_math_zone(spacing, last, indent)
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

        def mathml_paren(field, intent)
          unicodemath_syntax = ["&#x3016;", "&#x3017;", "&#x2524;", "&#x251c;"]
          paren = symbol_or_paren(field, lang: :mathml, intent: intent)
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

        def symbol_or_paren(field, lang:, intent: false)
          return field&.value unless field.is_a?(Math::Symbols::Paren)

          case lang
          when :mathml, :html
            field.to_mathml_without_math_tag(intent).nodes.first
          when :latex
            field.to_latex
          when :omml
            field.to_omml_without_math_tag(true)
          end
        end

        def intent_value(value)
          return "binomial-coefficient" if binomial_coefficient?(value)

          open_paren = symbol_or_paren(parameter_one, lang: :latex)
          close_paren = symbol_or_paren(parameter_three, lang: :latex)
          return "fenced" unless interval_intent?(value, open_paren, close_paren)

          interval_intent(value, open_paren, close_paren)
        end

        def binomial_coefficient?(value)
          parameter_two.first.is_a?(Frac) &&
            parameter_two&.first&.options&.dig(:choose)
        end

        def interval_intent(value, open_paren, close_paren)
          case open_paren
          when "("
            'open-closed-interval' if close_paren == ']'
          when "["
            return 'closed-interval' if close_paren == ']'

            'closed-open-interval' if (close_paren == '[' || close_paren == ')')
          when "]"
            return 'open-closed-interval' if close_paren == ']'

            'open-interval' if close_paren == '['
          end
        end

        def interval_intent?(value, open_paren, close_paren)
          return if value.length != 5
          return unless interval_intent_value?(value)

          case open_paren
          when "(" then close_paren == ']'
          when "]" then ['[', ']'].include?(close_paren)
          when "[" then ['[', ']', ')'].include?(close_paren)
          end
        end

        def interval_intent_value?(value)
          return unless value[2].nodes.first == ","

          valid_intent_value?(value[1]) &&
            valid_intent_value?(value[3])
        end

        def valid_intent_value?(node)
          case node.name
          when "mrow"
            return true if all_specific_nodes?(node.nodes, "mn")

            all_specific_nodes?(node.nodes, ["mo", "mi"])
          when "mi", "mo" then match_node_value?(node, /[A-Za-z]/)
          when "mn" then match_node_value?(node, /[0-9]/)
          end
        end

        def all_specific_nodes?(nodes, array)
          nodes.all? { |node| Array(array).include?(node.name) }
        end

        def match_node_value?(node, regex)
          node.nodes.first.match?(regex)
        end

        def mathml_value(intent)
          nodes = parameter_two&.map { |object| object&.to_mathml_without_math_tag(intent) }
          if intent
            mrow = Utility.update_nodes(ox_element("mrow"), nodes)
            update_partial_derivative(nodes) unless mrow.locate("*/mfrac/@intent").empty?
          end
          nodes
        end

        def update_partial_derivative(nodes)
          nodes.reduce do |first, second|
            if valid_partial_node(first)
              if %w[mfrac mo].include?(second.name)
                first["intent"].gsub!("$f", "")
              else
                second["arg"] = "f"
              end
            end
            second
          end
        end

        def valid_partial_node(node)
          return unless node.name == "mfrac"

          node["intent"]&.start_with?(":partial-derivative") &&
            !node.locate("*/@arg").include?("f")
        end
      end
    end
  end
end
