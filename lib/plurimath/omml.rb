# frozen_string_literal: true

module Plurimath
  class Omml
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

    autoload :FormulaTransformation, "#{__dir__}/omml/formula_transformation"
    autoload :Parser, "#{__dir__}/omml/parser"
    autoload :Translator, "#{__dir__}/omml/translator"
    autoload :UnsupportedNodeError,
             "#{__dir__}/errors/omml/unsupported_node_error"

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
