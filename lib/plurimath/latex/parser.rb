# frozen_string_literal: true

require_relative "parse"
require_relative "constants"
require_relative "transform"
module Plurimath
  class Latex
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text.gsub(" ", "").gsub("\n", "")
      end

      def parse
        tree_t = Plurimath::Latex::Parse.new.parse(text)
        formula = Plurimath::Latex::Transform.new.apply(tree_t)
        formula = [formula] unless formula.is_a?(Array)

        Plurimath::Math::Formula.new(formula)
      end
    end
  end
end
