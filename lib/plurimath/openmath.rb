# frozen_string_literal: true

require "openmath"

module Plurimath
  # The OpenMath notation: OpenMath 2 and 3 XML parsed through the openmath
  # gem into a Formula (plurimath#585). The evaluated surface — the bound
  # content-dictionary core (nums1, arith1, relation1, logic1) — converts
  # to Formula nodes; symbols outside the converter's table refuse rather
  # than lose meaning silently.
  class Openmath
    autoload :Converter, "#{__dir__}/openmath/converter"

    attr_accessor :text, :version

    def initialize(text, version: 2)
      @text = text
      @version = version
    end

    def to_formula
      Converter.new(::Openmath.parse(@text, version: @version)).to_formula
    end
  end
end
