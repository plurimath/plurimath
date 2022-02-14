# frozen_string_literal: true

require_relative "asciimath/function/sin"
require_relative "asciimath/function/tan"
require_relative "asciimath/function/cos"
require_relative "asciimath/number"
require_relative "asciimath/symbol"
require_relative "asciimath/variable"
module Plurimath
  # Asciimath Class
  class Asciimath
    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      # TODO: Will be implemented soon
    end
  end
end
