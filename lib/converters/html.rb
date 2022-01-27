# frozen_string_literal: true

# Html
class Html
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_mathml
    response = HTML2AsciiMath.convert(text)
    MathMl.new(response)
  end
end
