# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Ms < Mml::V4::Ms
        include OrderedChildren

        # MathML <ms> is a string literal element. Its content (child elements
        # and text nodes) is flattened into a single string. Child elements
        # contribute their text content, not their mathematical structure.
        def to_plurimath
          parts = ordered_children.filter_map { |child| extract_text(child) }
          text = parts.join(" ")
          Math::Function::Ms.new(text.empty? ? nil : text)
        end

        private

        # Extract text content from an Mml node or string.
        def extract_text(node)
          return (node.empty? ? nil : node) if node.is_a?(String)

          # Token elements (mi, mn, mo, ms, mtext) — extract value directly
          if token_element?(node)
            return Array(node.value).join
          end

          # Structural elements — recursively extract text from children
          if node.respond_to?(:ordered_children)
            return node.ordered_children
                       .filter_map { |c| extract_text(c) }
                       .join(" ")
          end

          # Fallback
          Array(node.value).join if node.respond_to?(:value)
        end

        def token_element?(node)
          node.is_a?(Mml::V4::Mi) ||
            node.is_a?(Mml::V4::Mn) ||
            node.is_a?(Mml::V4::Mo) ||
            node.is_a?(Mml::V4::Ms) ||
            node.is_a?(Mml::V4::Mtext)
        end
      end
      Models.register_model(Ms, id: :ms)
    end
  end
end
