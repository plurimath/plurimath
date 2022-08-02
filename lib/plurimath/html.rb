# frozen_string_literal: true

module Plurimath
  class Html
    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
