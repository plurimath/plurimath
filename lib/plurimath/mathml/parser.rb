# frozen_string_literal: true

require_relative "constants"
require_relative "transform"
module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text
      end

      def parse
        ox_nodes = Ox.load(text, strip_namespace: true).nodes
        nodes = parse_nodes(ox_nodes)
        Math::Formula.new(
          Transform.new.apply(nodes).flatten.compact,
        )
      end

      def parse_nodes(nodes)
        nodes.map do |node|
          next if node.is_a?(Ox::Comment)

          if node.is_a?(String)
            node
          elsif !node.attributes.empty?
            {
              node.name.to_sym => {
                attributes: node.attributes.transform_keys(&:to_sym),
                value: parse_nodes(node.nodes),
              },
            }
          else
            { node.name.to_sym => parse_nodes(node.nodes) }
          end
        end
      end
    end
  end
end
