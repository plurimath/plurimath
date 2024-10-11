# frozen_string_literal: true

require_relative "math"
require "mml/configuration"

module Plurimath
  class Mathml
    attr_accessor :text

    def initialize(text)
      ::Mml::Configuration.config = {
        mstyle: Plurimath::Math::Formula,
        math: Plurimath::Math::Formula,
        mrow: Plurimath::Math::Formula,
        mn: Plurimath::Math::Number,
        mi: Plurimath::Math::Symbols::Symbol,
      }
      ::Mml.adapter = :nokogiri
      # MML configuration
      @text = text
    end

    def to_formula
      Parser.new(text).parse
    end
  end
end
