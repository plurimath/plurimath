# frozen_string_literal: true

require 'omml2mathml'
# This class is responsible for converting Omml expressions to Mathml.
# @example
# file_name = "test.html"
# Omml.new(filename).to_mathml # =>
# <?xml version=\"1.0\"?>
# <!DOCTYPE html>
# <html xmlns:m=\"http://schemas.microsoft.com/office/2004/12/omml\">
# <head>
#   <meta charset=\"utf-8\"/>
#   <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/>
#   <title>Test</title>
# </head>
# <body>
#   <h3>Rspec test case in progress</h3>
# </body>
# </html>
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
