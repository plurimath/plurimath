# frozen_string_literal: true

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
        transformed_tree = Transform.new.apply(nodes)
        return transformed_tree if transformed_tree.is_a?(Math::Formula)

        Math::Formula.new(transformed_tree)
      end

      private

      def normalized_text
        text.gsub(HTML_ENTITY) do |entity|
          decoded_entity = Utility.html_entity_to_unicode(entity)

          Utility.string_to_html_entity(decoded_entity)
        end
      end
    end
  end
end
