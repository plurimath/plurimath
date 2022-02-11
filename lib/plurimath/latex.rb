# frozen_string_literal: true

module Plurimath
  # Latex Class
  class Latex
    attr_accessor :text

    def initialize(str)
      @text = str
    end

    def to_formula
      # TODO: Will be implemented soon
    end
  end
end
