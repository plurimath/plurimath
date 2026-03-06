# frozen_string_literal: true

require_relative "errors"
require_relative "asciimath"
require_relative "omml"
require_relative "unicode_math"
require_relative "mathml"
require_relative "html"
require_relative "latex"
require_relative "unitsml"
require_relative "number_formatter"
require_relative "formatter/standard"
require_relative "math/core"
require_relative "math/number"
require_relative "math/symbols"
require_relative "math/formula"
require_relative "math/formula/mrow"
require_relative "math/formula/mstyle"
require_relative "math/function"
require_relative "asciimath/parser"
require_relative "unicode_math/parser"
require_relative "mathml/parser"
require_relative "latex/parser"
require_relative "html/parser"
require_relative "omml/parser"
require_relative "utility"
require "yaml"

module Plurimath
  module Math
    VALID_TYPES = {
      omml: Omml,
      html: Html,
      latex: Latex,
      mathml: Mathml,
      unitsml: Unitsml,
      unicode: UnicodeMath,
      asciimath: Asciimath,
    }.freeze

    def parse(text, type)
      raise InvalidTypeError.new unless valid_type?(type)

      begin
        klass = klass_from_type(type)
        formula = klass.new(text).to_formula
        formula.input_string = text
        formula
      rescue => ee
        raise ParseError.new(text, type), cause: nil
      end
    end

    private

    def klass_from_type(type_string_or_sym)
      VALID_TYPES[type_string_or_sym.to_sym]
    end

    def valid_type?(type)
      (type.is_a?(::Symbol) || type.is_a?(String)) &&
        VALID_TYPES.key?(type.to_sym)
    end

    module_function :parse, :klass_from_type, :valid_type?
  end
end
