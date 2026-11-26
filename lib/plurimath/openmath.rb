# frozen_string_literal: true

require "openmath"

module Plurimath
  # The OpenMath notation: OpenMath 2 and 3 XML parsed through the openmath
  # gem into a Formula (plurimath#585). The evaluated surface — the bound
  # content-dictionary core (nums1, arith1, relation1, logic1) — converts
  # to Formula nodes; symbols outside the converter's table refuse rather
  # than lose meaning silently.
  class Openmath
    autoload :Semantic, "#{__dir__}/openmath/semantic"
    autoload :Evaluation, "#{__dir__}/openmath/evaluation"
    autoload :Writer, "#{__dir__}/openmath/writer"
    autoload :Symbol, "#{__dir__}/openmath/symbol"
    autoload :Converter, "#{__dir__}/openmath/converter"
    autoload :UnsupportedError, "#{__dir__}/openmath/unsupported_error"

    attr_accessor :text, :version

    def initialize(text, version: 2)
      @text = text
      @version = version
    end

    def to_formula
      ::Openmath.validate!(@text, version: @version)
      from_object(::Openmath.parse(@text, version: @version))
    rescue ::Openmath::Validation::ValidationError => e
      raise UnsupportedError.new(e.message, :openmath)
    end

    def from_object(object)
      formula = Converter.new(object).to_formula
      formula.openmath_source = object
      formula.openmath_snapshot = formula.cloned_objects
      formula
    end
  end
end
