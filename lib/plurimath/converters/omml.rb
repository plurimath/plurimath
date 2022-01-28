# frozen_string_literal: true

require 'omml2mathml'
# This class is responsible for converting Omml expressions to Mathml.
# @example
# file_name = "test.html"
# Omml2Mathml.convert(filename) # =>
# "<?xml version=\"1.0\"?>\n<!DOCTYPE html>\n<html xmlns:m=\"http://schemas.microsoft.com/office/2004/12/omml\">\n
# <head>\n  <meta charset=\"utf-8\"/>\n  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/>\n
# <title>Test</title>\n</head>\n<body>\n  <h3>Rspec test case in progress</h3>\n</body>\n</html>\n"
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
