require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Asciimath do

  it 'returns instance of Asciimath' do
    expect(Asciimath.new('rspec')).to be_a(Asciimath)
  end

  it 'returns unitsml instance' do
    expect(Asciimath.new('rspec').to_unitsml).to be_a(Unitsml)
  end

  it 'converts asciimath to unitsml' do
    converted_str = "<?xml version=\"1.0\"?>\n<math xmlns=\"http://www.w3.org/1998/Math/MathML\">\n  <mi>r</mi>\n  <mi>s</mi>\n  <mi>p</mi>\n  <mi>e</mi>\n  <mi>c</mi>\n</math>\n"
    expect(Asciimath.new('rspec').to_unitsml.text).to eql(converted_str)
  end
end

