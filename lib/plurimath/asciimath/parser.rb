# frozen_string_literal: true

require_relative "parse"
require_relative "constants"
require_relative "transform"
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
        nodes = Parse.new.parse(text)
        transformed_tree = Transform.new.apply(nodes)
        return transformed_tree if transformed_tree.is_a?(Math::Formula)

        Math::Formula.new(transformed_tree)
      end
    end
  end
end
