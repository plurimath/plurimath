# frozen_string_literal: true

require "unitsml"
module Plurimath
  class Unitsml
    attr_accessor :text

    def initialize(text)
      @text = text
      raise Math::ParseError.new(error_message) if text.match?(/\^(\([^\d-])|[^\d-]\)/)
    end

    def to_formula
      ::Unitsml.parse(text).to_plurimath
    end

    def error_message
      <<~MESSAGE
       [plurimath] Invalid formula `#{@text}`.
       [plurimath] The use of a variable as an exponent is not valid.
       [plurimath] If this is a bug, please report the formula at our issue tracker at:
       [plurimath] https://github.com/plurimath/plurimath/issues
      MESSAGE
    end
  end
end
