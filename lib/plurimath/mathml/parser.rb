# frozen_string_literal: true

module Plurimath
  class Mathml
    class Parser
      # Matches a math root tag, including prefixed forms, only when that tag
      # carries an xmlns or xmlns:* declaration.
      ROOT_MATH_NAMESPACE_PATTERN =
        /<(?:[\w.-]+:)?math\b[^>]*\sxmlns(?::[\w.-]+)?\s*=/.freeze

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
        text.match?(ROOT_MATH_NAMESPACE_PATTERN)
      end
    end
  end
end
