# frozen_string_literal: true

require_relative "constants"
require_relative "transform"
module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      SUPPORTED_ATTRS = %w[
        columnlines
        mathvariant
        accentunder
        mathcolor
        notation
        accent
        close
        open
      ].freeze

      def initialize(text)
        @text = text
      end

      def parse
        ox_nodes = Plurimath.xml_engine.load(text)
        display_style = ox_nodes&.locate("mstyle/@displaystyle")&.first
        nodes = parse_nodes(ox_nodes.nodes)
        Math::Formula.new(
          Transform.new.apply(nodes).flatten.compact,
          display_style: (display_style || true),
        )
      end

      def parse_nodes(nodes)
        nodes.map do |node|
          next if Plurimath.xml_engine.is_xml_comment?(node)

          if node.is_a?(String)
            node
          elsif !node.attributes.empty?
            attrs_hash(node)
          else
            { node.name.to_sym => parse_nodes(node.nodes) }
          end
        end
      end

      def validate_attributes(attributes)
        attributes&.select! { |key, _| SUPPORTED_ATTRS.include?(key.to_s) }
        attributes&.transform_keys(&:to_sym) if attributes&.any?
      end

      def attrs_hash(node)
        {
          node.name.to_sym => {
            attributes: validate_attributes(node.attributes),
            value: parse_nodes(node.nodes),
          },
        }
      end
    end
  end
end
