# frozen_string_literal: true

require "mml"

module Plurimath
  class Mathml
    class Parser
      attr_accessor :text
      @@models_set = false

      def initialize(text)
        @text = text
      end

      def parse
        namespace_exist = text.split(">").first.include?(" xmlns=")
        mml_math = Mml.parse(text, namespace_exist: namespace_exist, version: 4)
        Translator.new.mml_to_plurimath(mml_math)
      end
    end
  end
end
