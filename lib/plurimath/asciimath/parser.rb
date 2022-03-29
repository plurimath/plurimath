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
        new_nodes = Parse.new.parse(text)
        tree_t = Plurimath::Asciimath::Transform.new.apply(new_nodes)
        Plurimath::Math::Formula.new(tree_t)
      end
    end
  end
end
