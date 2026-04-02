# frozen_string_literal: true

module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text
      end

      def parse
        Mml.parse(
          text,
          version: 4,
          register: Models.register,
          namespace_exist: namespace_exist?,
        ).to_plurimath
      end

      private

      def namespace_exist?
        text.split(">").first.include?(" xmlns=")
      end
    end
  end
end
