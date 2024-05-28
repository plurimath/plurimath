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
          return node.nodes.first if INTENT_TEXT_NODES.include?(node.name)

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
        def function_intent(tag, _)
          tag.attributes["intent"] = ":function"
          tag
        end
      # Function intent end
      end
    end
  end
end
