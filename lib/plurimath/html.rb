# frozen_string_literal: true

module Plurimath
  class Html
    autoload :Constants, "#{__dir__}/html/constants"
    autoload :Parse, "#{__dir__}/html/parse"
    autoload :Parser, "#{__dir__}/html/parser"
    autoload :Transform, "#{__dir__}/html/transform"

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
