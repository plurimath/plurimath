# frozen_string_literal: true

require_relative "transform"
module Plurimath
  class Omml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text
      end

      def parse
        nodes = Ox.load(text, strip_namespace: true)
        @hash = { sequence: parse_nodes(nodes.nodes) }
        nodes = JSON.parse(@hash.to_json, symbolize_names: true)
        Math::Formula.new(
          Transform.new.apply(
            nodes,
          ),
        )
      end

      def parse_nodes(nodes)
        nodes.map do |node|
          if node.is_a?(String)
            node
          elsif !node.attributes.empty?
            {
              node.name => {
                attributes: node.attributes,
                value: parse_nodes(node.nodes),
              },
            }
          else
            { node.name => parse_nodes(node.nodes) }
          end
        end
      end
    end
  end
end
