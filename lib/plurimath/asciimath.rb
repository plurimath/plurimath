# frozen_string_literal: true

require_relative "math/function"
require_relative "math/number"
require_relative "math/symbol"
require_relative "math/variable"
module Plurimath
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
