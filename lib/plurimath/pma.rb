# frozen_string_literal: true

module Plurimath
  # pma, the strict ASCII dialect of AsciiMath (docs/pma.adoc). amath reads
  # it with Amath.parse(text, dialect: :pma) and the AsciiMath mapper builds
  # the formula, so a measured value is the same Uncertainty node that the
  # :asciimath input type builds.
  class Pma
    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      Asciimath::Parser.new(text, dialect: :pma).parse
    end
  end
end
