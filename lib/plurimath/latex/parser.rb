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
        @text = gsub_text(text)
      end

      def parse
        tree_t = Parse.new.parse(text)
        formula = Transform.new.apply(tree_t)
        formula = [formula] unless formula.is_a?(Array)

        Math::Formula.new(formula)
      end

      private

      def gsub_text(text)
        text.partition(/\\(mbox|text){[^}]*}/).map do |str|
          text_str = true if str.start_with?(/\\(text|mbox)/)

          gsub_space_and_unicodes(str, text_str)
        end.join
      end

      def gsub_space_and_unicodes(text, text_str)
        text = text.gsub(/((?<!\\) )|\n+/, "") unless text_str
        text
          .gsub(/\\\\ /, "\\\\\\\\")
          .gsub(/&#x26;/, "&")
          .gsub(/&#x22;/, "\"")
          .gsub(/(?<!\\\\)\\&#xa;/, "\\ ")
          .gsub(/&#xa;/, "")
      end
    end
  end
end
