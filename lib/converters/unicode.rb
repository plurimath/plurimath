# frozen_string_literal: true

# Unicode
class Unicode
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_mathml
    response = Unicode2LaTeX.unicode2latex(text)
    MathMl.new(response)
  end
end
