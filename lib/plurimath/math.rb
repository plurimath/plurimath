# frozen_string_literal: true

require_relative "unicode"
require_relative "asciimath"
require_relative "omml"
require_relative "mathml"
require_relative "html"
require_relative "latex"
require_relative "unitsml"
require_relative "math/base"
require_relative "math/number"
require_relative "math/symbol"
require_relative "math/unicode"
require_relative "math/formula"
require_relative "math/function"
require_relative "asciimath/parser"
require_relative "mathml/parser"
require_relative "latex/parser"
require_relative "html/parser"
require_relative "omml/parser"
require_relative "utility"
require "ox"
Ox.default_options = { encoding: "UTF-8" }

module Plurimath
  module Math
    class ParseError < StandardError; end
    class InvalidTypeError < TypeError; end

    VALID_TYPES = {
      omml: Omml,
      html: Html,
      latex: Latex,
      mathml: Mathml,
      unitsml: Unitsml,
      unicode: Unicode,
      asciimath: Asciimath,
    }.freeze

    def parse(text, type)
      type_error! unless valid_type?(type)

      begin
        klass = klass_from_type(type)
        klass.new(text).to_formula
      rescue => ee
        parse_error!(text, type.to_sym)
      end
    end

    private

    def klass_from_type(type_string_or_sym)
      VALID_TYPES[type_string_or_sym.to_sym]
    end

    def parse_error!(text, type)
      message = <<~MESSAGE
        [plurimath] Error: Failed to parse the following formula with type `#{type}`.
        [plurimath] Please first manually validate the formula.
        [plurimath] If this is a bug, please report the formula at our issue tracker at:
        [plurimath] https://github.com/plurimath/plurimath/issues
        ---- FORMULA BEGIN ----
        #{text}
        ---- FORMULA END ----
      MESSAGE
      raise ParseError.new(message), cause: nil
    end

    def type_error!
      raise InvalidTypeError.new(
        "`type` must be one of: `#{VALID_TYPES.keys.join('`, `')}`"
      )
    end

    def valid_type?(type)
      (type.is_a?(::Symbol) || type.is_a?(String)) &&
        VALID_TYPES.key?(type.to_sym)
    end

    module_function :parse, :klass_from_type, :parse_error!, :type_error!, :valid_type?
  end
end
