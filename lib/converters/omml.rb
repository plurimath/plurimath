# frozen_string_literal: true

# Omml
class Omml
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_mathml
    response = Omml2Mathml.convert(text)
    MathMl.new(response)
  end
end
