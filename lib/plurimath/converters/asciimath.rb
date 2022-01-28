# frozen_string_literal: true

require 'asciimath2unitsml'
# @example
# html_string = "rspec"
# Asciimath2UnitsML::Conv.new.Asciimath2UnitsML(html_string) # =>
# "<?xml version=\"1.0\"?>\n<math xmlns=\"http://www.w3.org/1998/Math/MathML\">\n  "\
# "<mi>r</mi>\n  <mi>s</mi>\n  <mi>p</mi>\n  <mi>e</mi>\n  <mi>c</mi>\n</math>\n"
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
