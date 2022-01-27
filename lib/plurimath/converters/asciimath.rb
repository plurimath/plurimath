# frozen_string_literal: true

require 'asciimath2unitsml'
# Asciimath
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
