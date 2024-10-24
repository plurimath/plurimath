# frozen_string_literal: true

require_relative "constants"
require_relative "transform"
require "mml/configuration"

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
        intent
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
        mml_config
        @text = text
      end

      def parse
        ::Mml.parse(text)
      end

      protected

      def mml_config
        ::Mml::Configuration.config = {
          munderover: Plurimath::Math::Function::Underover,
          semantics: Plurimath::Math::Function::Semantics,
          mscarries: Plurimath::Math::Function::Scarries,
          mlongdiv: Plurimath::Math::Function::Longdiv,
          msubsup: Plurimath::Math::Function::PowerBase,
          msgroup: Plurimath::Math::Function::Msgroup,
          mfenced: Plurimath::Math::Function::Fenced,
          mstack: Plurimath::Math::Function::Stackrel,
          munder: Plurimath::Math::Function::Underset,
          msline: Plurimath::Math::Function::Msline,
          mtable: Plurimath::Math::Function::Table,
          mstyle: Plurimath::Math::Formula::Mstyle,
          merror: Plurimath::Math::Function::Merror,
          mover: Plurimath::Math::Function::Overset,
          msqrt: Plurimath::Math::Function::Sqrt,
          mroot: Plurimath::Math::Function::Root,
          mtext: Plurimath::Math::Function::Text,
          mfrac: Plurimath::Math::Function::Frac,
          msrow: Plurimath::Math::Formula::Msrow,
          msup: Plurimath::Math::Function::Power,
          msub: Plurimath::Math::Function::Base,
          none: Plurimath::Math::Function::None,
          mrow: Plurimath::Math::Formula::Mrow,
          math: Plurimath::Math::Formula,
          mtd: Plurimath::Math::Function::Td,
          mtr: Plurimath::Math::Function::Tr,
          mi: Plurimath::Math::Symbols::Symbol,
          mo: Plurimath::Math::Symbols::Symbol,
          ms: Plurimath::Math::Function::Ms,
          mn: Plurimath::Math::Number,
        }
        require "mml" unless ::Mml.respond_to?(:config)
      end

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
        nodes.delete_if { |node| Plurimath.xml_engine.is_xml_comment?(node) }
      end
    end
  end
end
