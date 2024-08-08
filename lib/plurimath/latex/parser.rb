# frozen_string_literal: true

require_relative "parse"
require_relative "constants"
require_relative "transform"
module Plurimath
  class Latex
    class Parser
      attr_accessor :text

      TEXT_REGEX = %r(\\(?:mbox|text)\{[^\}]+\})

      def initialize(text)
        @text = pre_processing(text)
      end

      def parse
        tree_t = Parse.new.parse(text)
        formula = Transform.new.apply(tree_t)
        formula = [formula] unless formula.is_a?(Array)

        Math::Formula.new(formula)
      end

      private

      def pre_processing(text)
        text_functions = text.scan(TEXT_REGEX)
        enti = HTMLEntities.new
        text = enti.encode(enti.decode(text), :hexadecimal)
        text = gsub_space_and_unicodes(text)
        text.gsub(TEXT_REGEX) { |str| text_functions.shift }
      end

      def gsub_space_and_unicodes(text)
        text
          .gsub(/((?<!\\) )|\n+/, "")
          .gsub(/\\\\ /, "\\\\\\\\")
          .gsub(/&#x26;/, "&")
          .gsub(/&#x22;/, "\"")
          .gsub(/(?<!\\\\)\\&#xa;/, "\\ ")
          .gsub(/&#xa;/, "")
      end
    end
  end
end
