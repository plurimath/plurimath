# frozen_string_literal: true

require_relative "parse"
require_relative "constants"
require_relative "transform"
module Plurimath
  class Latex
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text.gsub(/\s/, "")
      end

      def parse
        tree_t = Latex::Parse.new.parse(text)
        tree_t = JSON.parse(tree_t.to_json, symbolize_names: true)
        formula = Latex::Transform.new.apply(tree_t)
        formula = [formula] unless formula.is_a?(Array)

        Math::Formula.new(formula)
      end
    end
  end
end
