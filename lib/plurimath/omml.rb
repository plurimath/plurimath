# frozen_string_literal: true

module Plurimath
  class Omml
    autoload :Parser, "#{__dir__}/omml/parser"
    autoload :Transform, "#{__dir__}/omml/transform"

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
