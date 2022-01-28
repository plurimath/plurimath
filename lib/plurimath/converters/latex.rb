# frozen_string_literal: true

require 'latexmath'
# @example
# html_string = "rspec"
# Latexmath.parse(html_string).to_mathml # =>
# "<math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"><mrow><mi>&#x00072;</mi><mi>&#x00073;"\
# "</mi><mi>&#x00070;</mi><mi>&#x00065;</mi><mi>&#x00063;</mi></mrow></math>"
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
