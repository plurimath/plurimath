# frozen_string_literal: true

require_relative "ternary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Fenced < TernaryFunction
        include Mathml::Utility

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

        def to_asciimath(options:)
          first_value  = parameter_one ? parameter_one.to_asciimath(options: options) : "("
          third_value  = parameter_three ? parameter_three.to_asciimath(options: options) : ")"
          second_value = parameter_two&.map { |param| param.to_asciimath(options: options) }&.join(' ')
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          first_value = ox_element("mo", attributes: self.options&.dig(:open_paren)) << (mathml_paren(parameter_one, intent, options: options) || "")
          third_value = ox_element("mo", attributes: self.options&.dig(:close_paren)) << (mathml_paren(parameter_three, intent, options: options) || "")
          mrow_value = Array(mathml_value(intent, options: options))&.insert(0, first_value) << third_value
          fenced = Utility.update_nodes(ox_element("mrow"), mrow_value)
          intentify(
            fenced,
            intent,
            func_name: :interval_fence,
            intent_name: intent_value(mrow_value, options: options),
            options: intent_names,
          )
        end

        def to_html(options:)
          first_value  = "<i>#{symbol_or_paren(parameter_one, lang: :html, options: options)}</i>" if parameter_one
          second_value = parameter_two.map { |param| param.to_html(options: options) }.join if parameter_two
          third_value  = "<i>#{symbol_or_paren(parameter_three, lang: :html, options: options)}</i>" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_latex(options:)
          fenced_value = parameter_two&.map { |param| param.to_latex(options: options) }&.join(" ")
          first_value  = latex_paren(symbol_or_paren(parameter_one, lang: :latex, options: options))
          second_value = latex_paren(symbol_or_paren(parameter_three, lang: :latex, options: options))
          "#{first_value} #{fenced_value} #{second_value}"
        end

        def to_omml_without_math_tag(display_style, options:)
          attrs = { "m:val": (options ? options[:separators] : "") }
          d = Utility.ox_element("d", namespace: "m")
          dpr = Utility.ox_element("dPr", namespace: "m")
          open_paren(dpr, options: options)
          dpr << Utility.ox_element("sepChr", namespace: "m", attributes: attrs)
          close_paren(dpr, options: options)
          Utility.update_nodes(
            d,
            [
              dpr,
              omml_parameter(
                Formula.new(Array(parameter_two)),
                display_style,
                tag_name: "e",
                options: options,
              ),
            ],
          )
          [d]
        end

        def to_unicodemath(options:)
          return mini_sized_unicode(options: options) if mini_sized?

          fenced_value = parameter_two&.map do |param|
            next param.choose_frac(options: options) if choose_frac?(param)

            param.to_unicodemath(options: options)
          end&.join(" ")
          return fenced_value if choose_frac?(parameter_two.first)

          fenced_value = "(#{fenced_value})" if vert_paren?

          "#{unicode_open_paren(options: options)}#{fenced_value}#{unicode_close_paren(options: options)}"
        end

        def to_asciimath_math_zone(spacing, last = false, indent = true, options:)
          filtered_values(parameter_two, lang: :asciimath).map.with_index(1) do |object, index|
            new_last = index == @values.length && last
            object.to_asciimath_math_zone(spacing, new_last, indent, options: options)
          end
        end

        def to_latex_math_zone(spacing, last = false, indent = true, options:)
          filtered_values(parameter_two, lang: :latex).map.with_index(1) do |object, index|
            new_last = index == @values.length && last
            object.to_latex_math_zone(spacing, new_last, indent, options: options)
          end
        end

        def to_mathml_math_zone(spacing, last = false, indent = true, options:)
          filtered_values(parameter_two, lang: :mathml, options: options).map.with_index(1) do |object, index|
            new_last = index == @values.length && last
            object.to_mathml_math_zone(spacing, new_last, indent, options: options)
          end
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:, options:)
          filtered_values(parameter_two, lang: :omml).map do |object|
            object.to_omml_math_zone(spacing, last, !indent, display_style: display_style, options: options)
          end
        end

        def to_unicodemath_math_zone(spacing, last = false, indent = true, options:)
          filtered_values(parameter_two, lang: :unicodemath).map.with_index(1) do |object, index|
            new_last = index == @values.length && last
            object.to_unicodemath_math_zone(spacing, new_last, indent, options: options)
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

        def mini_sized_unicode(options:)
          fenced_value = parameter_two&.map { |param| param.to_unicodemath(options: options) }&.join
          "#{parameter_one.to_unicodemath(options: options)}#{fenced_value}#{parameter_three.to_unicodemath(options: options)}"
        end

        def intent_names
          {
            open_closed_interval: "open-closed-interval",
            closed_open_interval: "closed-open-interval",
            binomial_coefficient: "binomial-coefficient",
            closed_interval: "closed-interval",
            open_interval: "open-interval",
            fenced: ":fenced",
          }
        end

        def separators=(value)
          return if value.nil?

          @options[:separators] = value
        end

        def content=(value)
          if parens_nil?
            @parameter_one = Math::Symbols::Paren::Lround.new
            @parameter_three = Math::Symbols::Paren::Rround.new
          end
        end

        def open=(value)
          return unless value

          @parameter_one = validate_symbols(value)
        end

        def close=(value)
          return unless value

          @parameter_three = validate_symbols(value)
        end

        def element_order=(value)
          @parameter_two = validated_order(value&.map(&:name))
        end

        def mi_value=(value)
          return if value.nil? || value.empty?

          update(
            replace_order_with_value(
              @parameter_two,
              Array(validate_symbols(value)),
              "mi"
            )
          )
        end

        def mn_value=(value)
          return if value.nil? || value.empty?

          update(
            replace_order_with_value(
              @parameter_two,
              Array(validate_symbols(value)),
              "mn"
            )
          )
        end

        def mtext_value=(value)
          return if value.nil? || value.empty?

          update(
            replace_order_with_value(
              @parameter_two,
              Array(validate_symbols(value)),
              "mtext"
            )
          )
        end

        def mo_value=(value)
          return if value.nil? || value.empty?

          update(
            replace_order_with_value(
              @parameter_two,
              Array(validate_symbols(value)),
              "mo"
            )
          )
        end

        def mstyle_value=(value)
          return if value.nil? || value.empty?

          update(
            replace_order_with_value(
              @parameter_two,
              Array(value),
              "mstyle"
            )
          )
        end

        def munderover_value=(value)
          update_temp_order(value, "munderover")
        end

        def msub_value=(value)
          update_temp_order(value, "msub")
        end

        def msup_value=(value)
          update_temp_order(value, "msup")
        end

        def mover_value=(value)
          update_temp_order(value, "mover")
        end

        def munder_value=(value)
          update_temp_order(value, "munder")
        end

        def msubsup_value=(value)
          update_temp_order(value, "msubsup")
        end

        def mfrac_value=(value)
          update_temp_order(value, "mfrac")
        end

        def msqrt_value=(value)
          update_temp_order(value, "msqrt")
        end

        def mfenced_value=(value)
          update_temp_order(value, "mfenced")
        end

        def mtable_value=(value)
          return if value.nil? || value.empty?

          update(
            replace_order_with_value(
              Array(@parameter_two),
              update_temp_mathml_values(value),
              "mtable"
            )
          )
        end

        def mrow_value=(value)
          return if value.nil? || value.empty?

          update(
            replace_order_with_value(
              Array(@parameter_two),
              update_temp_mathml_values(
                Array(filter_values(value, array_to_instance: true))
              ),
              "mrow"
            )
          )
        end

        def mspace_value=(value)
          return if value.nil? || value.empty?

          if value.first.linebreak
            linebreak = Math::Function::Linebreak.new(
              nil,
              { linebreak: value.first.linebreak }
            )

            update(
              replace_order_with_value(
                Array(@parameter_two),
                [linebreak],
                "mspace"
              )
            )
          else
            @parameter_two&.delete("mspace")
          end
        end

        def mpadded_value=(value)
          update_temp_order(value, "mpadded")
        end

        def mfraction_value=(value)
          update_temp_order(value, "mfraction")
        end

        def mmultiscripts_value=(value)
          update_temp_order(value, "mmultiscripts")
        end

        def mphantom_value=(value)
          update_temp_order(value, "mphantom")
        end

        protected

        def update_temp_order(value, order_name)
          return if value.nil? || value.empty?

          update(
            replace_order_with_value(
              Array(@parameter_two),
              update_temp_mathml_values(value),
              order_name
            )
          )
        end

        def remove_order(order)
          @parameter_two.delete_if { |val| val.is_a?(String) && val == order }
        end

        def insert(values)
          update(Array(@parameter_two) + values)
        end

        def update(object)
          @parameter_two = Array(object)
        end

        def open_paren(dpr, options:)
          first_value = symbol_or_paren(parameter_one, lang: :omml, options: options)
          return dpr if first_value.nil?

          attributes = { "m:val": Utility.html_entity_to_unicode(first_value) }
          dpr << Utility.ox_element(
            "begChr",
            namespace: "m",
            attributes: attributes,
          )
        end

        def close_paren(dpr, options:)
          third_value = symbol_or_paren(parameter_three, lang: :omml, options: options)
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

        def mathml_paren(field, intent, options:)
          unicodemath_syntax = ["&#x3016;", "&#x3017;", "&#x2524;", "&#x251c;"]
          paren = symbol_or_paren(field, lang: :mathml, intent: intent, options: options)
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

        def unicode_open_paren(options:)
          paren = parameter_one&.to_unicodemath(options: options)
          return "├#{convert_paren_size(paren_size: self.options&.dig(:open_paren, :minsize))}#{paren}" if self.options&.key?(:open_paren)
          return "├#{paren}" if self.options&.key?(:open_prefixed) && !open_or_begin?
          return "├" if self.options&.key?(:open_prefixed) || paren == "{:"

          paren
        end

        def unicode_close_paren(options:)
          paren = parameter_three&.to_unicodemath(options: options)
          return "┤#{convert_paren_size(paren_size: self.options&.dig(:close_paren, :minsize))}#{paren}" if self.options&.key?(:close_paren)
          return "┤#{paren}" if self.options&.key?(:close_prefixed) && !close_or_end?
          return "┤" if self.options&.key?(:close_prefixed) || paren == ":}"

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

        def symbol_or_paren(field, lang:, intent: false, options: {})
          return field&.value unless field.is_a?(Math::Symbols::Paren)

          case lang
          when :mathml, :html
            field.to_mathml_without_math_tag(intent, options: options).nodes.first
          when :latex
            field.to_latex(options: options)
          when :omml
            field.to_omml_without_math_tag(true, options: options)
          end
        end

        def intent_value(value, options:)
          return :binomial_coefficient if binomial_coefficient?(value)

          open_paren = symbol_or_paren(parameter_one, lang: :latex, options: options)
          close_paren = symbol_or_paren(parameter_three, lang: :latex, options: options)
          return :fenced unless interval_intent?(value, open_paren, close_paren)

          interval_intent(value, open_paren, close_paren)
        end

        def binomial_coefficient?(value)
          parameter_two&.first&.is_a?(Frac) &&
            parameter_two&.first&.options&.dig(:choose)
        end

        def interval_intent(value, open_paren, close_paren)
          case open_paren
          when "("
            :open_closed_interval if close_paren == ']'
          when "["
            return :closed_interval if close_paren == ']'

            :closed_open_interval if (close_paren == '[' || close_paren == ')')
          when "]"
            return :open_closed_interval if close_paren == ']'

            :open_interval if close_paren == '['
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

        def mathml_value(intent, options:)
          nodes = parameter_two&.map { |object| object&.to_mathml_without_math_tag(intent, options: options) }
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
                first["intent"] = first["intent"].gsub("$f", "")
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

        def parens_nil?
          @parameter_one.nil? && @parameter_three.nil?
        end
      end
    end
  end
end
