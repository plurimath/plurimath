# frozen_string_literal: true

module Plurimath
  class Omml
    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Math::Formula.new([Parse.new(text).parse])
    end
  end
end
