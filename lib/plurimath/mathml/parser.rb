# frozen_string_literal: true

module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text
      end

      def parse
        mml_tree = Mml.parse(
          text,
          version: 4,
          namespace_exist: namespace_exist?,
        )

        Mathml::Translator.new.mml_to_plurimath(mml_tree)
      end

      private

      def namespace_exist?
        text.split(">").first.include?(" xmlns=")
      end
    end
  end
end
