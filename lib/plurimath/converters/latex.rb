# frozen_string_literal: true

require 'latexmath'
# Latex
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
