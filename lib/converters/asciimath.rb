# frozen_string_literal: true

# Asciimath
class Asciimath
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_mathml
    response = Asciimath2UnitsML::Conv.new.Asciimath2UnitsML(text)
    MathMl.new(response)
  end
end
