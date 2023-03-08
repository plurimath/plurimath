# frozen_string_literal: true

require_relative "parse"
require_relative "transform"
module Plurimath
  class Unitsml
    class Parser
      attr_accessor :text

      def initialize(text)
        text = text&.match(/unitsml\((.*)\)/)
        @text = text[1] if text
      end

      def parse
        nodes = Parse.new.parse(text)
        transformed_tree = Transform.new.apply(nodes)
        Math::Formula.new(transformed_tree)
      end
    end
  end
end
