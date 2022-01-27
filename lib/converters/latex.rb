# frozen_string_literal: true

# Latex
class Latex
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_mathml
    response = Latexmath.parse(text).to_mathml
    MathMl.new(response)
  end
end
