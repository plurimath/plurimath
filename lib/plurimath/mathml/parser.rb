# frozen_string_literal: true

require_relative "constants"
require_relative "transform"
module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      SUPPORTED_ATTRS = %w[
        linebreakstyle
        linethickness
        columnlines
        mathvariant
        accentunder
        separators
        linebreak
        mathcolor
        notation
        bevelled
        rowlines
        accent
        height
        frame
        depth
        height
        width
        index
        close
        alt
        src
        open
      ].freeze

      def initialize(text)
        @text = text
      end

      def parse
        ox_nodes = Plurimath.xml_engine.load(text)
        display_style = ox_nodes&.locate("mstyle/@displaystyle")&.first
        nodes = parse_nodes(Array(ox_nodes))
        Math::Formula.new(
          Transform.new.apply(nodes).flatten.compact,
          display_style: (display_style || true),
        )
      end

      protected

      def parse_nodes(nodes)
        nodes.map do |node|
          next if Plurimath.xml_engine.is_xml_comment?(node)

          if node.is_a?(String)
            node
          elsif !node.attributes.empty?
            attrs_hash(node)
          else
            manage_tags(node)
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

      def manage_tags(node)
        if node.name == "ms"
          Plurimath::xml_engine.replace_nodes(
            node,
            ms_tag(comment_remove(node.nodes)).join(" "),
          )
        end
        { node.name.to_sym => parse_nodes(node.nodes) }
      end

      def ms_tag(nodes)
        return nodes if nodes.any?(String)

        nodes.map do |node|
          if node.nodes.any?(String)
            node.nodes
          else
            ms_tag(node.nodes)
          end
        end
      end

      def comment_remove(nodes)
        nodes.delete_if { |node| Plurimath.xml_engine.is_xml_comment?(node)  }
      end
    end
  end
end
