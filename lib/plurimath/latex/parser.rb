# frozen_string_literal: true

require_relative "parse"
require_relative "constants"
require_relative "transform"
module Plurimath
  class Latex
    class Parser
      attr_accessor :text

      def initialize(text)
        enti = HTMLEntities.new
        text = enti.encode(enti.decode(text), :hexadecimal)
        text = text
          .gsub(/((?<!\\) )|\n+/, "")
          .gsub(/\\\\ /, "\\\\\\\\")
          .gsub(/&#x26;/, "&")
          .gsub(/&#x22;/, "\"")
          .gsub(/&#xa;/, "")
        @text = text
      end

      def parse
        tree_t = Parse.new.parse(text)
        formula = Transform.new.apply(tree_t)
        formula = [formula] unless formula.is_a?(Array)

        Math::Formula.new(formula)
      end
    end
  end
end
