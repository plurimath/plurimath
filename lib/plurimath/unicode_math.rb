# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    autoload :Constants, "#{__dir__}/unicode_math/constants"
    autoload :Mapper, "#{__dir__}/unicode_math/mapper"
    autoload :Parse, "#{__dir__}/unicode_math/parse"
    autoload :Parser, "#{__dir__}/unicode_math/parser"
    autoload :Utility, "#{__dir__}/unicode_math/utility"

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
