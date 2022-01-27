# frozen_string_literal: true

require 'mathml2asciimath'
# Mathml
class Mathml
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_asciimath
    response = MathML2AsciiMath.m2a(text)
    Asciimath.new(response)
  end
end
