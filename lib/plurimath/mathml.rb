# frozen_string_literal: true

require "strscan"
require_relative "math"
module Plurimath
  class Mathml
    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      # TODO: Will be implemented soon
      string = StringScanner.new(@text)
      @text = Plurimath::Mathml::Parser.new(string).parse
    end
  end
end
