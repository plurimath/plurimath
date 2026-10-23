# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text
          &.gsub(/(\|:|:\|)/, "|")
          &.gsub(/(\{:)/, "ℒ")
          &.gsub(/(:\})/, "ℛ")
          &.gsub(/(\(:)/, "ᑕ")
          &.gsub(/(:\))/, "ᑐ")
      end

      def parse
        nodes = parse_tree
        transformed_tree = Transform.new.apply(nodes)
        return transformed_tree if transformed_tree.is_a?(Math::Formula)

        Math::Formula.new(transformed_tree)
      end

      private

      # amath parses with a compiled Parsanol grammar; SliceAdapter turns its
      # tree back into the Parslet-shaped tree Asciimath::Transform expects.
      def parse_tree
        require "amath"

        tree = ::Amath.parse(text, decimal: Plurimath.configuration.decimal)
        SliceAdapter.convert(tree, text)
      end
    end
  end
end
