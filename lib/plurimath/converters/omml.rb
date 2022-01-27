# frozen_string_literal: true

require 'omml2mathml'
# Omml
class Omml
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_mathml
    response = Omml2Mathml.convert(text)
    Mathml.new(response)
  end
end
