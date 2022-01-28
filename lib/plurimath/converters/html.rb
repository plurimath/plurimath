# frozen_string_literal: true

require 'html2asciimath'
# @example
#   html_string = "<h3>rspec</h3>"
#   HTML2AsciiMath.convert(html_string) # => "\"rspec\""
class Html
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_asciimath
    response = HTML2AsciiMath.convert(text)
    Asciimath.new(response)
  end
end
