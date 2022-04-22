# frozen_string_literal: true

require_relative "parse"
require_relative "constants"
require "parslet/convenience"
module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text.gsub("\n", "").gsub(" ", "")
      end

      def parse
        tree_t = Plurimath::Mathml::Parse.new.parse(text)
      end
    end
  end
end
