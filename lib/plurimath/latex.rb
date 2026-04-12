# frozen_string_literal: true

module Plurimath
  class Latex
    autoload :Constants, "#{__dir__}/latex/constants"
    autoload :Parse, "#{__dir__}/latex/parse"
    autoload :Parser, "#{__dir__}/latex/parser"
    autoload :Transform, "#{__dir__}/latex/transform"

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
