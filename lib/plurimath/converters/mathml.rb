# frozen_string_literal: true

require 'mathml2asciimath'
# @example
# html_string = "<cn> 0 </cn>"
# MathML2AsciiMath.m2a(html_string) # =>
# <math xmlns=\"http://www.w3.org/1998/Math/MathML\"><cn> 0 </cn></math>
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
