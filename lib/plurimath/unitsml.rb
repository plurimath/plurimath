# frozen_string_literal: true

require "unitsml"
module Plurimath
  class Unitsml
    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      ::Unitsml.parse(text).to_plurimath
    end
  end
end
