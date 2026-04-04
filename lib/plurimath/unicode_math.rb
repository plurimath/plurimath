# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    autoload :Constants, "#{__dir__}/unicode_math/constants"
    autoload :Parse, "#{__dir__}/unicode_math/parse"
    autoload :Parser, "#{__dir__}/unicode_math/parser"
    autoload :ParsingRules, "#{__dir__}/unicode_math/parsing_rules"
    autoload :Transform, "#{__dir__}/unicode_math/transform"

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
