# frozen_string_literal: true

require 'mathml2asciimath'
# This class is responsible for converting Mathml expressions to asciimath.
# @example
# html_string = "<o>example</o>"
# Mathml.new(html_string).to_asciimath # =>
# <math xmlns=\"http://www.w3.org/1998/Math/MathML\">
#   <o>example</o>
# </math>
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
