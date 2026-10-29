# frozen_string_literal: true

require "json"

module Plurimath
  class Html
    class Parser
      HTML_ENTITY = /&(?:#x[0-9a-f]+|#\d+|[a-z][a-z0-9]+);/i

      attr_accessor :text

      def initialize(text)
        @text = text.to_s
      end

      def parse
        nodes = Parse.new.parse(normalized_text)
        nodes = JSON.parse(normalized_nodes(nodes).to_json, symbolize_names: true)
        transformed_tree = Transform.new.apply(nodes)
        return transformed_tree if transformed_tree.is_a?(Math::Formula)

        Math::Formula.new(transformed_tree)
      end

      private

      def normalized_nodes(node, depth = 0)
        if depth >= 100 && (node.is_a?(Hash) || node.is_a?(Array))
          raise JSON::NestingError, "nesting of #{depth + 1} is too deep"
        end

        case node
        when Parsanol::Slice then node.to_s
        when Hash then node.transform_values { |child| normalized_nodes(child, depth + 1) }
        when Array then node.map { |child| normalized_nodes(child, depth + 1) }
        else node
        end
      end

      def normalized_text
        text.gsub(HTML_ENTITY) do |entity|
          decoded_entity = Utility.html_entity_to_unicode(entity)

          Utility.string_to_html_entity(decoded_entity)
        end
      end
    end
  end
end
