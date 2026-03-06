# frozen_string_literal: true

require "unitsml"
module Plurimath
  class Unitsml
    attr_accessor :text

    VALID_UNITSML = %r{\^(([^\s][^*\/,"]*?[a-z]+)|(\([^-\d]+\)|[^\(\d-]+))}

    def initialize(text)
      @text = text
      raise Math::ParseError.new(text, :unitsml_parse_error) if text.match?(VALID_UNITSML)
    end

    def to_formula
      Math::Function::Unitsml.new(text)
    end
  end
end
