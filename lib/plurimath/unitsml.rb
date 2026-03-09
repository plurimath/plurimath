# frozen_string_literal: true

require "unitsml"
module Plurimath
  class Unitsml
    attr_accessor :text

    # Match ^ followed by content containing letters (indicating variables as exponents, which are invalid)
    # Simplified regex to avoid catastrophic backtracking (ReDoS vulnerability)
    VALID_UNITSML = /\^\(?-?\d*[a-z]/i

    def initialize(text)
      @text = text
      raise Math::ParseError.new(text, :invalid_unitsml) if text.match?(VALID_UNITSML)
    end

    def to_formula
      Math::Function::Unitsml.new(text)
    end
  end
end
