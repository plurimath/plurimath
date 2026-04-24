# frozen_string_literal: true

module Plurimath
  class Omml
    autoload :FormulaTransformation, "#{__dir__}/omml/formula_transformation"
    autoload :Parser, "#{__dir__}/omml/parser"
    autoload :Translator, "#{__dir__}/omml/translator"
    autoload :Transform, "#{__dir__}/omml/transform"
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
