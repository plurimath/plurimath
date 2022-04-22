# frozen_string_literal: true

module Plurimath
  class Mathml
    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Plurimath::Mathml::Parser.new(text).parse
    end
  end
end
