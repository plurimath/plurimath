# frozen_string_literal: true

require "omml"
module Plurimath
  class Omml
    class Parser
      attr_accessor :text

      CUSTOMIZABLE_TAGS = %w[
        eqArr
        sPre
        mr
        r
      ].freeze
      SUPPORTED_FONTS = {
        "sans-serif-bi": "sans-serif-bold-italic",
        "double-struck": "double-struck",
        "sans-serif-i": "sans-serif-italic",
        "sans-serif-b": "bold-sans-serif",
        "sans-serif-p": "sans-serif",
        "fraktur-p": "fraktur",
        "fraktur-b": "bold-fraktur",
        "script-b": "bold-script",
        "script-p": "script",
        monospace: "monospace",
        bi: "bold-italic",
        p: "normal",
        i: "italic",
        b: "bold",
      }.freeze

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
