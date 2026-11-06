# frozen_string_literal: true

module Plurimath
  class Asciimath
    autoload :Constants, "#{__dir__}/asciimath/constants"
    autoload :Mapper, "#{__dir__}/asciimath/mapper"
    autoload :Parse, "#{__dir__}/asciimath/parse"
    autoload :Parser, "#{__dir__}/asciimath/parser"
    autoload :SliceAdapter, "#{__dir__}/asciimath/slice_adapter"
    autoload :Utility, "#{__dir__}/asciimath/utility"

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
