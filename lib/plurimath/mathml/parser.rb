# frozen_string_literal: true

require_relative "constants"
require_relative "transform"
module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      SUPPORTED_ATTRIBUTES = %w[
        columnlines
        mathvariant
        mathcolor
        notation
        close
        open
      ].freeze

      def initialize(text)
        @text = text
      end

      def parse
        ox_nodes = Ox.load(text, strip_namespace: true)
        display_style = ox_nodes&.locate("*/mstyle/@displaystyle")&.first || true
        nodes = parse_nodes(ox_nodes.nodes)
        Math::Formula.new(
          Transform.new.apply(nodes).flatten.compact,
          displaystyle: display_style,
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
                attributes: validate_attributes(node.attributes),
                value: parse_nodes(node.nodes),
              },
            }
          else
            { node.name.to_sym => parse_nodes(node.nodes) }
          end
        end
      end

      def validate_attributes(attributes)
        attributes&.select! { |key, _| SUPPORTED_ATTRIBUTES.include?(key&.to_s) }
        attributes&.transform_keys(&:to_sym) if attributes&.any?
      end
    end
  end
end
