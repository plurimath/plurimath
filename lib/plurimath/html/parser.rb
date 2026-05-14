# frozen_string_literal: true

require "json"

module Plurimath
  class Html
    class Parser
      MATHML_ROOT_TAG = %r{<\s*/?\s*math(?:\s|/?>)}i
      HTML_ENTITY = /&(?:#x[0-9a-f]+|#\d+|[a-z][a-z0-9]+);/i

      attr_accessor :text

      def initialize(text)
        @text = text.to_s
      end

      def parse
        validate_html_input!

        nodes = Parse.new.parse(normalized_text)
        nodes = JSON.parse(nodes.to_json, symbolize_names: true)
        transformed_tree = Transform.new.apply(nodes)
        return transformed_tree if transformed_tree.is_a?(Math::Formula)

        Math::Formula.new(transformed_tree)
      end

      private

      def validate_html_input!
        return unless text.match?(MATHML_ROOT_TAG)

        raise Parslet::ParseFailed,
              "MathML input must be parsed with the MathML parser"
      end

      def normalized_text
        text.gsub(HTML_ENTITY) do |entity|
          decoded_entity = Utility.html_entity_to_unicode(entity)

          %w[< >].include?(decoded_entity) ? Utility.string_to_html_entity(decoded_entity) : decoded_entity
        end
      end
    end
  end
end
