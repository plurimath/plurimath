# frozen_string_literal: true

require 'html2asciimath'
# This class is responsible for converting Html expressions to Asciimath.
# @example
# html_string = "<h3>example</h3>"
# HTML2AsciiMath.convert(html_string) # => "\"example\""
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
