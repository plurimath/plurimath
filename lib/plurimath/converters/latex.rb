# frozen_string_literal: true

require 'latexmath'
# This class is responsible for converting Latex expressions to Mathml.
# @example
# html_string = "example"
# Latexmath.parse(html_string).to_mathml # =>
# "<math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"><mrow><mi>&#x00065;
# </mi><mi>&#x00078;</mi><mi>&#x00061;</mi><mi>&#x0006D;</mi><mi>&#x00070;</mi><mi>&#x0006C;
# </mi><mi>&#x00065;</mi></mrow></math>"
class Latex
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_mathml
    response = Latexmath.parse(text).to_mathml
    Mathml.new(response)
  end
end
