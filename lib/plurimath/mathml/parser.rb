# frozen_string_literal: true

require_relative "parse"
require_relative "constants"
require_relative "transform"
module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text.gsub(/\s/, "")
      end

      def parse
        tree_t = Plurimath::Mathml::Parse.new.parse(text)
        tree_t = JSON.parse(tree_t.to_json, symbolize_names: true)
        formula = Plurimath::Mathml::Transform.new.apply(tree_t)
        formula = [formula] unless formula.is_a?(Array) || formula.nil?
        return if formula.nil?

        Plurimath::Math::Formula.new(formula)
      end
    end
  end
end
