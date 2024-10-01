module Plurimath
  class Utility
    class IntentEncoding < Utility
      SUP_TAGS = %w[msup mover].freeze
      SUB_TAGS = %w[msub munder].freeze
      INTENT_TEXT_NODES = %w[mi mo mn].freeze

      class << self
        # Intent common code begin
        def node_value(node, field_name)
          return unless node
          return if node.name == "mo" && node.nodes[0] == "&#x2b1a;"
          return html_entity_to_unicode(node.nodes.first) if valid_node_value?(node)
          return all_numeric(node) if all_numeric?(node)

          node[:arg] = field_name
          "$#{field_name}"
        end
        # Intent common code end

        # Naryand intent begin
        def naryand_intent(field, intent_name, options)
          return nary_intent(field, intent_name, options) if field.name == "mrow"

          base, power = power_base_intent(field)
          base, power = power_or_base_intent(field) unless base && power
          field["intent"] = "#{intent_name}(#{base},#{power})"
          field
        end

        def nary_intent(field, intent_name, _)
          sub_sup = field.nodes[0]
          base, power = power_base_intent(sub_sup)
          base, power = power_or_base_intent(sub_sup) unless base || power
          naryand = node_value(field.nodes[1], "naryand")
          field["intent"] = "#{intent_name}(#{base},#{power},#{naryand})"
          field
        end
        # Naryand intent end

        # SubSup intent begin
        def power_base_intent(field)
          return nil unless ["munderover", "msubsup"].include?(field.name)

          base = node_value(field.nodes[1], "l")
          power = node_value(field.nodes[2], "h")
          [base, power]
        end

        def power_or_base_intent(field)
          value_node = field.nodes[1]
          return nil unless SUP_TAGS.include?(field.name) || SUB_TAGS.include?(field.name)
          return [nil, node_value(value_node, "h")] if SUP_TAGS.include?(field.name)

          [node_value(value_node, "l"), nil]
        end
        # SubSup intent end

        # Function intent begin
        def function_intent(tag, intent_name = ":function", _)
          tag.attributes["intent"] = intent_name
          tag
        end
        # Function intent end

        # Binomial fraction intent begin
        def binomial_fraction_intent(tag, intent_name, _)
          numerator = node_value(tag.nodes[1].nodes[0], "t")
          denominator = node_value(tag.nodes[1].nodes[1], "b")
          tag["intent"] = "#{intent_name}(#{numerator},#{denominator})"
          tag
        end
        # Binomial fraction intent end

        # Interval fence intent begin
        def interval_fence_intent(tag, intent_name, options)
          intent = options[intent_name]
          return function_intent(tag, intent, options) if intent_name == :fenced
          return binomial_fraction_intent(tag, intent, options) if intent_name == :binomial_coefficient

          first_value = fence_node_value(tag.nodes[1], "a")
          second_value = fence_node_value(tag.nodes[3], "b")
          tag["intent"] = "#{intent}(#{first_value},#{second_value})"
          tag
        end
        # Interval fence intent end

        # Frac derivative intent begin
        def frac_intent(tag, _, options)
          num = tag.nodes[0]
          den = tag.nodes[1]
          return partial_derivative(tag, options[:partial_derivative]) if partial_derivative?(num, den)
          return derivative(tag, options[:derivative]) if derivative?(num, den)

          tag
        end
        # Frac derivative intent end

        # Abs intent begin
        def abs_intent(tag, intent_name, _options)
          tag["intent"] = "#{intent_name}(#{node_value(tag.nodes[1], 'a')})"
          tag
        end
        # Abs intent end

        private

        def fence_node_value(tag, arg_name)
          return node_value(tag, arg_name) unless infty_nodes?(tag&.nodes)

          first_node = html_entity_to_unicode(tag.nodes.first.nodes.first)
          last_node = html_entity_to_unicode(tag.nodes.last.nodes.first)
          arg_name = "#{first_node}#{last_node}"
          tag[:arg] = arg_name
          arg_name
        end

        def infty_nodes?(nodes)
          return unless nodes&.length == 2

          ["&#x2212;", "-", "+"].include?(nodes&.first&.nodes&.first) &&
            ["&#x221e;"].include?(nodes&.last&.nodes&.first)
        end

        def valid_node_value?(node)
          INTENT_TEXT_NODES.include?(node.name) ||
            node.name == "mrow" && node.nodes.empty?
        end

        # Frac Partial derivative intent begin
        # num == numerator && den == denominator
        def partial_derivative?(num, den)
          validate_field_and_value(num) &&
            validate_field_and_value(den)
        end

        def validate_field_and_value(node, parent_node = nil)
          case node.name
          when "mo"
            node.nodes[0] == "&#x2202;"
          when "mrow"
            validate_field_and_value(node.nodes[0], node)
          when "msup", "msubsup"
            if validate_field_and_value(node.nodes[0], parent_node)
              wrap_in_mrow(parent_node) if parent_node
              true
            end
          end
        end

        def find_power_base_nodes(node)
          return node.nodes[1] if %w[msup msubsup].include?(node&.name)

          found_node = node.nodes.find { |node| %w[msup msubsup].include?(node&.name) }
          return unless found_node

          found_node&.nodes[1]
        end

        def partial_derivative(node, intent_name)
          intent = "(#{partial_arg(node)},#{f_arg(node&.nodes[0])},#{den_arg(node&.nodes[1])})"
          node["intent"] = intent_name + intent
          node
        end

        def f_arg(node)
          nodes = node&.nodes[1..-1]
          all_m_tags = nodes&.all? { |element| element.name == "mi" }
          return insert_f_arg(node, nodes) unless all_m_tags

          nodes&.first&.nodes&.first
        end

        def insert_f_arg(node, nodes)
          if !nodes.empty? && !%w[msup msubsup].include?(node.name)
            mrow = ox_element("mrow", attributes: { arg: "$f" })
            Plurimath.xml_engine.replace_nodes(
              node,
              [
                node.nodes.first,
                update_nodes(mrow, nodes),
              ],
            )
          end
          "$f"
        end

        def den_arg(node, nodes = [])
          str = []
          case node.name
          when "mo" then str = extract_string(nodes[1..-1], str)
          when "msup" then str = power_arg(node.nodes, str)
          when "mrow" then str << den_arg(node.nodes.first, node.nodes)
          end
          str.join(",")
        end

        def power_arg(nodes, str)
          nodes[0].each do |node|
            next if node.nodes[0] == "&#x2202;"

            str << html_entity_to_unicode(node.nodes[0])
          end
          str.last << nodes[1].nodes[0] if primes_constants.value?(nodes[1].nodes[0])
          str
        end

        def wrap_in_mrow(node)
          nodes = node&.nodes[1..-1]
          return if nodes&.empty?

          mrow = ox_element("mrow", attributes: { arg: "n" })
          update_nodes(mrow, nodes)
          replace_nodes = [node.nodes.first.xml_nodes, mrow.xml_nodes.nodes]
          Plurimath.xml_engine.replace_nodes(node, replace_nodes.flatten)
          node
        end

        def extract_string(nodes, str)
          nodes.each do |node|
            case node.name
            when "mi"
              str << html_entity_to_unicode(node.nodes.first)
            when "msup", "msubsup"
              str << html_entity_to_unicode(node.nodes.first.nodes.first)
            end
          end
          str
        end

        def partial_arg(node)
          found_node = find_power_base_nodes(node.nodes[0])
          return "1" unless found_node

          case found_node.name
          when "mo", "mi", "mn"
            html_entity_to_unicode(found_node.nodes.first)
          else
            "$n"
          end
        end
        # Frac Partial derivative intent end

        # Frac derivative intent begin
        def derivative?(num, den)
          return unless num || den

          valid_derivative?(num) && valid_derivative?(den)
        end

        def valid_derivative?(node)
          return node.nodes.first.match?(/(&#x214(6|5);)|^d$/) if INTENT_TEXT_NODES.include?(node.name)

          node.nodes.first.name == "mi" &&
            node.nodes.first.nodes.first.match?(/(&#x214(6|5);)|^d$/) &&
            node.nodes.length >= 2
        end

        def derivative(node, intent_name)
          num = node.nodes[0]
          den = node.nodes[1]
          node["intent"] = "#{intent_name}(1,#{num_arg(num)},#{derivative_den_arg(den)})"
          node
        end

        def num_arg(num)
          return "$f" if num.nodes.length <= 1

          case num.nodes[1].name
          when "mi", "mo", "mn"
            num.nodes[1].nodes.first
          else
            num.nodes[1]["arg"] = "f"
            "$f"
          end
        end

        def derivative_den_arg(den)
          return if den.nodes.length <= 1

          den.nodes[1].nodes.first
        end
        # Frac derivative intent end

        # Intent common but private begin
        def all_numeric?(node)
          return unless node.name == "mrow"

          node.nodes.all? { |element| element.name == "mn" }
        end

        def all_numeric(node)
          str = ""
          node.nodes.each { |element| str += element.nodes.first }
          str
        end
        # Intent common but private end
      end
    end
  end
end
