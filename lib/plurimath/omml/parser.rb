# frozen_string_literal: true

require_relative "constants"
require_relative "transform"
module Plurimath
  class Omml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = CGI.unescape(text)
      end

      def parse
        nodes = Ox.load(text, strip_namespace: true)
        @hash = { sequence: parse_nodes(nodes.nodes) }
        Math::Formula.new(
          Transform.new.apply(
            JSON.parse(@hash.to_json, symbolize_names: true),
          ),
        )
      end

      def parse_nodes(nodes)
        nodes.map do |node|
          if node.is_a?(String)
            node
          elsif !node.attributes.empty?
            { node.name => node.attributes }
          elsif Constants::SUB_SUP_TAG.include?(node.name)
            { node.name => sub_sup_hash(node.nodes) }
          else
            { node.name => parse_nodes(node.nodes) }
          end
        end
      end

      def sub_sup_hash(nodes)
        new_hash = {}
        nodes.map do |node|
          if new_hash.key?(node.name)
            new_hash[node.name] += parse_nodes(node.nodes)
          else
            new_hash[node.name] = parse_nodes(node.nodes)
          end
        end
        new_hash
      end
    end
  end
end
