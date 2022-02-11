# frozen_string_literal: true

require_relative 'asciimath_parser'
module Plurimath
  # Asciimath Class
  class Asciimath
    attr_accessor :text

    def initialize(str)
      @text = str
    end

    def to_formula
      # TODO: Will be implemented soon
    end
  end
end
