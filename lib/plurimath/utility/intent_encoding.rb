module Plurimath
  class Utility
    class IntentEncoding < Utility
      INTENT_TEXT_NODES = %w[mi mo mn]

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
        def naryand_intent(field, class_name)
          return nary_intent(field, class_name) if field.name = "mrow"
        end

        def nary_intent(field, class_name)
          sub_sup = field.nodes[0]
          if ["munderover", "msubsup"].include?(sub_sup.name)
            base = node_value(sub_sup.nodes[1], "l")
            power = node_value(sub_sup.nodes[2], "h")
          else
            type = ["msup", "mover"].include?(sub_sup.name) ? "h" : "l"
            type == "h" ? power = node_value(sub_sup.nodes[1], "h") : base = node_value(sub_sup.nodes[1], "l")
          end
          naryand = node_value(field.nodes[1], "naryand")
          field[:intent] = ":#{class_name}(#{base}, #{power}, #{naryand})"
          field
        end
        # Naryand intent end
        # Frac intent begin
        def frac_intent(frac)
          numerator = node_value(frac.nodes[0], "num")
          denominator = node_value(frac.nodes[1], "denom")
          frac[:intent] = ":divide(#{numerator}, #{denominator})"
          frac
        end
      end
    end
  end
end
