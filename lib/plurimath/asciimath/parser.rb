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
      end

      def parse
        nodes = Parse.new.parse(text)
        tranformed_tree = Plurimath::Asciimath::Transform.new.apply(nodes)
        return tranformed_tree if tranformed_tree.is_a?(Plurimath::Math::Formula)

        Plurimath::Math::Formula.new(tranformed_tree)
      end
    end
  end
end
