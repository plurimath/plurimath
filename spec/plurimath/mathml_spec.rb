require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Mathml do

  it 'returns instance of Mathml' do
    mathml = Plurimath::Mathml.new('<mrow><mn>2</mn></mrow>')
    expect(mathml).to be_a(Plurimath::Mathml)
  end

  it 'returns Asciimath instance' do
    mathml = Plurimath::Mathml.new('<mrow><mn>2</mn></mrow>')
    expect(mathml.text).to eql('<mrow><mn>2</mn></mrow>')
  end
end
