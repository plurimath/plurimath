# frozen_string_literal: true

module Plurimath
  class Html
    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      # TODO: Will be implemented soon
    end
  end
end