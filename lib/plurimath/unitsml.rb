# frozen_string_literal: true

require "unitsml"
module Plurimath
  class Unitsml
    attr_accessor :text

    VALID_UNITSML = %r{\^(([^\s][^*\/,"]*?[a-z]+)|(\([^-\d]+\)|[^\(\d-]+))}

    def initialize(text)
      @text = text
      raise Math::ParseError.new(error_message) if text.match?(VALID_UNITSML)
    end

    def to_formula
      Math::Function::Unitsml.new(text)
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
