module Plurimath
  class Utility
    class IntentEncoding < Utility
      SUP_TAGS = %w[msup mover].freeze
      SUB_TAGS = %w[msub munder].freeze
      INTENT_TEXT_NODES = %w[mi mo mn].freeze
      INTENT_VALUES = {
        divide: %w[num denom],
      }.freeze

      class << self
      # Intent common code begin
        def node_value(node, field_name)
          return unless node
          return html_entity_to_unicode(node.nodes.first) if valid_node_value?(node)

          node[:arg] = field_name
          "$#{field_name}"
        end
      # Intent common code end

      # Naryand intent begin
        def naryand_intent(field, intent_name)
          return nary_intent(field, intent_name) if field.name == "mrow"

          base, power = power_base_intent(field)
          base, power = power_or_base_intent(field) unless base && power
          field[:intent] = ":#{intent_name}(#{base},#{power})"
          field
        end

        def nary_intent(field, intent_name)
          sub_sup = field.nodes[0]
          base, power = power_base_intent(sub_sup)
          base, power = power_or_base_intent(sub_sup) unless base && power
          naryand = node_value(field.nodes[1], "naryand")
          field[:intent] = ":#{intent_name}(#{base},#{power},#{naryand})"
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
        def function_intent(tag, intent_name = "function")
          tag.attributes["intent"] = ":#{intent_name}"
          tag
        end
      # Function intent end

      # Binomial fraction intent begin
        def binomial_fraction_intent(tag, intent_name)
          numerator = node_value(tag.nodes[1].nodes[0], "t")
          denominator = node_value(tag.nodes[1].nodes[1], "b")
          tag[:intent] = "#{intent_name}(#{numerator},#{denominator})"
          tag
        end
      # Binomial fraction intent end

      # Interval fence intent begin
        def interval_fence_intent(tag, intent_name)
          return function_intent(tag, intent_name) if intent_name == "fenced"
          return binomial_fraction_intent(tag, intent_name) if intent_name == "binomial-coefficient"

          first_value = fence_node_value(tag.nodes[1], "a")
          second_value = fence_node_value(tag.nodes[3], "b")
          tag[:intent] = "#{intent_name}(#{first_value},#{second_value})"
          tag
        end
      # Interval fence intent end

      # Frac derivative intent begin
        def frac_intent(tag, intent_name)
          return partial_derivative(tag) if partial_derivative?(tag.nodes[0], tag.nodes[1])
          # derivative if derivative?(tag[0], tag[1])
          tag
        end
      # Frac derivative intent end

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

        # Frac derivative intent begin
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

        def partial_derivative(node)
          intent = "($n,#{f_arg(node&.nodes[0])},#{den_arg(node&.nodes[1])})"
          node[:intent] = ":partial-derivative#{intent}"
          node
        end

        def f_arg(node)
          nodes = node&.nodes
          all_mi = nodes&.all? { |element| element.name == "mi" }
          return "$f" unless all_mi

          nodes&.first
        end

        def den_arg(node, nodes = [])
          str = ""
          case node.name
          when "mo" then str = extract_string(nodes[1..-1], str)
          when "mrow" then den_arg(node.nodes.first, node.nodes)
          end
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
              str += html_entity_to_unicode(node.nodes.first)
            when "msup", "msubsup"
              str += html_entity_to_unicode(node.nodes.first.nodes.first)
            end
          end
          str
        end
        # Frac derivative intent end
      end
    end
  end
end
