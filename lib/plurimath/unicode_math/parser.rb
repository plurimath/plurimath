# frozen_string_literal: true

require "parslet"
require "parslet/convenience"
require_relative "parse"
require_relative "transform"
require_relative "constants"
module Plurimath
  class UnicodeMath
    class Parser
      attr_accessor :text

      LABELED_TR_REGEX = /"([^"]*(#|&#x23;|\\\\eqno)[^"]*[^"]*|[^"]*(#|&#x23;|\\\\eqno)[^"]*[^"]*)"/

      def initialize(text)
        text = pre_processing(text)
        @text = HTMLEntities.new.encode(text, :hexadecimal)
        @text = @text.gsub("&#x26;", "&")
        @text = @text.gsub("&#x22;", "\"")
        @text = @text.gsub(/&#x2af7;.*&#x2af8;/, "")
        @text = @text.gsub(/\\\\/, "\\")
        @text = @text.gsub(/\\u([\da-fA-F]{1,5})\w{0,5}/) { "&#x#{$1};" } # Converting \u#{xxxx} encoding to &#x#{xxxx};
        @text = @text.strip
      end

      def parse
        tree = Parse.new.parse(text)
        tree = post_processing(tree) if @splitted
        Math::Formula.new(
          Array(
            Transform.new.apply(tree),
          ),
        )
      end

      private

      def post_processing(tree)
        {
          labeled_tr_value: tree,
          labeled_tr_id: @splitted
        }
      end

      def pre_processing(text)
        text unless text.include?("#") && !text.match?(LABELED_TR_REGEX)

        text = text.gsub(/✎\(.*(\#).*\)/) do |str|
          str = str.gsub("#", "\"replacement\"")
        end
        splitted = text.split("#")
        splitted[0] = splitted.first.gsub("\"replacement\"", "#")
        @splitted = splitted.last if splitted.count > 1
        splitted.first
      end
    end
  end
end
