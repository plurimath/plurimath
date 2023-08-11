# frozen_string_literal: true

require_relative "transform"
module Plurimath
  class Omml
    class Parser
      attr_accessor :text

      CUSTOMIZABLE_TAGS = %w[
        eqArr
        mr
        r
      ].freeze

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
            node == "​" ? nil : node
          elsif !node.attributes.empty?
            {
              node.name => {
                attributes: node.attributes,
                value: parse_nodes(node.nodes),
              },
            }
          else
            customize_tags(node) if CUSTOMIZABLE_TAGS.include?(node.name)
            { node.name => parse_nodes(node.nodes) }
          end
        end
      end

      def customize_tags(node)
        case node.name
        when "r"
          organize_fonts(node)
        when "mr", "eqArr"
          organize_table_td(node)
        end
      end

      def organize_table_td(node)
        node.locate("e/?").each do |child_node|
          child_node.name = "mtd" if child_node.name == "r"
        end
      end

      def organize_fonts(node)
        attrs_arr = { val: [] }
        node.locate("rPr/?").each do |child|
          attrs_arr[:val] << child.attributes["val"]
        end
        node.attributes.merge! attrs_arr
      end
    end
  end
end
