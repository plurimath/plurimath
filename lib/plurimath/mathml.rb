# frozen_string_literal: true

module Plurimath
  class Mathml
    autoload :Constants, "#{__dir__}/mathml/constants"
    autoload :Parser, "#{__dir__}/mathml/parser"
    autoload :Utility, "#{__dir__}/mathml/utility"
    autoload :Models, "#{__dir__}/mathml/models"

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
