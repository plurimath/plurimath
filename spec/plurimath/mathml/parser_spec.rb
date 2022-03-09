require_relative "../../../lib/plurimath/mathml"
require "strscan"

RSpec.describe Plurimath::Mathml::Parser do

  it "returns instance of Cos formula against the string" do
    mathml = init_spec_resp('<math xmlns="http://www.w3.org/1998/Math/MathML"><mi></mi><msup><mi></mi><mn></mn></msup><mo></mo><mi></mi><mi></mi><mo>1</mo><annotation-xml></annotation-xml><mo></mo><mn></mn></math>')
  end
end

# initializing string for parsing and calling mathml's parser method
def init_spec_resp(equation)
  text = StringScanner.new(equation)
  Plurimath::Mathml::Parser.new(text).parse
end
