# frozen_string_literal: true

require 'asciimath2unitsml'
# This class is responsible for converting Asciimath expressions to UnitsMl.
# @example
# html_string = "example"
# Asciimath.new(html_string).to_unitsml # =>
# <?xml version=\"1.0\"?>
# <math xmlns=\"http://www.w3.org/1998/Math/MathML\">
#   <mi>e</mi>
#   <mi>x</mi>
#   <mi>a</mi>
#   <mi>m</mi>
#   <mi>p</mi>
#   <mo>&#x2264;</mo>
# </math>
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
