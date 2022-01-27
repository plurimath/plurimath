# frozen_string_literal: true

# Mathml
class Mathml
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_mathml
    response = MathML2AsciiMath.m2a(text)
    MathMl.new(response)
  end
end
