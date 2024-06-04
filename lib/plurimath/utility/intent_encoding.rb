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
          return unless nodes.length == 2

          ["&#x2212;", "-", "+"].include?(nodes&.first&.nodes&.first) &&
            ["&#x221e;"].include?(nodes&.last&.nodes&.first)
        end

        def valid_node_value?(node)
          INTENT_TEXT_NODES.include?(node.name) ||
            node.name == "mrow" && node.nodes.empty?
        end
      end
    end
  end
end
