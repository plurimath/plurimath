# frozen_string_literal: true

require "json"
require "cgi"
require_relative "parse"
require_relative "constants"
require_relative "transform"
module Plurimath
  class Html
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = ::CGI.unescapeHTML(text)
      end

      def parse
        nodes = Parse.new.parse(text)
        nodes = JSON.parse(nodes.to_json, symbolize_names: true)
        transformed_tree = Transform.new.apply(nodes)
        return transformed_tree if transformed_tree.is_a?(Math::Formula)

        Math::Formula.new(transformed_tree)
      end
    end
  end
end
