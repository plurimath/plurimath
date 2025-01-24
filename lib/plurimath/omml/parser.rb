# frozen_string_literal: true

require_relative "transform"
module Plurimath
  class Omml
    class Parser
      attr_accessor :text

      CUSTOMIZABLE_TAGS = %w[
        eqArr
        sPre
        mr
        r
      ].freeze
      SUPPORTED_FONTS = {
        "sans-serif-bi": "sans-serif-bold-italic",
        "double-struck": "double-struck",
        "sans-serif-i": "sans-serif-italic",
        "sans-serif-b": "bold-sans-serif",
        "sans-serif-p": "sans-serif",
        "fraktur-p": "fraktur",
        "fraktur-b": "bold-fraktur",
        "script-b": "bold-script",
        "script-p": "script",
        monospace: "monospace",
        bi: "bold-italic",
        p: "normal",
        i: "italic",
        b: "bold",
      }.freeze

      def initialize(text)
        @text = text
      end

      def parse
        nodes = Plurimath.xml_engine.load(text)
        @hash = { sequence: parse_nodes(nodes.nodes) }
        nodes = JSON.parse(@hash.to_json, symbolize_names: true)
        Math::Formula.new(
          Transform.new.apply(
            nodes,
          ),
        )
      end

      def parse_nodes(nodes)
        nodes.delete_if { |node| node.is_xml_comment? if node.respond_to?(:is_xml_comment?) }

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
        when "sPre"
          organize_spre(node)
        end
      end

      def organize_table_td(node)
        node.locate("e/*").each do |child_node|
          child_node.name = "mtd" if child_node.name == "r"
        end
      end

      def organize_fonts(node)
        attrs_arr = { val: [] }
        node.locate("rPr/*").each do |child|
          attrs_arr[:val] << child.attributes["val"]
        end
        node.set_attr attrs_arr
      end

      def organize_spre(node)
        node.locate("sub").first.name = "sPreSub"
        node.locate("sup").first.name = "sPreSup"
      end
    end
  end
end
