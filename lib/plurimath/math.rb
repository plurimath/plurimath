# frozen_string_literal: true

module Plurimath
  module Math
    autoload :Core, "#{__dir__}/math/core"
    autoload :Formula, "#{__dir__}/math/formula"
    autoload :Function, "#{__dir__}/math/function"
    autoload :InvalidTypeError, "#{__dir__}/errors/invalid_type_error"
    autoload :Number, "#{__dir__}/math/number"
    autoload :ParseError, "#{__dir__}/errors/parse_error"
    autoload :Symbols, "#{__dir__}/math/symbols"

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
      rescue ParseError
        # Re-raise ParseError from lower layers unchanged to preserve specialized error types
        raise
      rescue StandardError
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
