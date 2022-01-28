# frozen_string_literal: true

require 'asciimath2unitsml'
# This class is responsible for converting Asciimath expressions to UnitsMl.
# @example
# html_string = "example"
# Asciimath2UnitsML::Conv.new.Asciimath2UnitsML(html_string) # =>
# "<?xml version=\"1.0\"?>\n<math xmlns=\"http://www.w3.org/1998/Math/MathML\">\n  <mi>e</mi>\n
# <mi>x</mi>\n  <mi>a</mi>\n  <mi>m</mi>\n  <mi>p</mi>\n  <mo>&#x2264;</mo>\n</math>\n"
class Asciimath
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_unitsml
    response = Asciimath2UnitsML::Conv.new.Asciimath2UnitsML(text)
    Unitsml.new(response)
  end
end
