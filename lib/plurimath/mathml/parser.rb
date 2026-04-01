# frozen_string_literal: true

require_relative "models"

module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text
      end

      def parse
        namespace_exist = text.split(">").first.include?(" xmlns=")
        mml_tree = Mml.parse(
          text,
          version: 4,
          register: Models.register,
          namespace_exist: namespace_exist,
        )
        mml_tree.to_plurimath
      end
    end
  end
end
