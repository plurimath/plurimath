# frozen_string_literal: true

module Plurimath
  class Asciimath
    autoload :Constants, "#{__dir__}/asciimath/constants"
    autoload :Parse, "#{__dir__}/asciimath/parse"
    autoload :Parser, "#{__dir__}/asciimath/parser"
    autoload :Transform, "#{__dir__}/asciimath/transform"

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
