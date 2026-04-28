# frozen_string_literal: true

require "omml"
module Plurimath
  class Omml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text
      end

      def parse
        Translator.new.omml_to_plurimath(
          ::Omml.parse(text),
        )
      end
    end
  end
end
