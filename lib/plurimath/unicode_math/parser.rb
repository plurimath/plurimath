# frozen_string_literal: true

require "parslet"
require "parslet/convenience"
require_relative "parse"
require_relative "constants"
module Plurimath
  class UnicodeMath
    class Parser
      attr_accessor :text

      def initialize(text)
        text = if text.include?("#") && !text.match?(/"([^"]*#[^"]*[^"]*|[^"]*#[^"]*[^"]*)"/)
                 new_string = string.gsub!(/✎\(.*(\#).*\)/) { |str| str.gsub!("#", "\"replacement\"") }
                 splitted = new_string.split("#")
                 splitted.first.gsub!("\"replacement\"", "#")
                 @splitted = splitted.last if splitted.count > 1
                 splitted.first
               else
                 text
               end
        @text = HTMLEntities.new.encode(text, :hexadecimal)
        @text.gsub!("&#x26;", "&")
        @text.gsub!("&#x22;", "\"")
        @text.gsub!(/&#x2af7;.*&#x2af8;/, "")
        @text.gsub!(/\\\\/, "\\")
        @text.strip!
      end

      def parse
        tree = Parse.new.parse(text)
        tree = post_processing(tree) if @splitted
        Math::Formula.new([tree])
      end

      private

      def post_processing(tree)
        {
          labeled_tr_value: tree,
          labeled_tr_id: @splitted
        }
      end
    end
  end
end
