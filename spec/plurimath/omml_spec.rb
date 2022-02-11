require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath::Omml do

  it 'returns instance of Omml' do
    omml = Plurimath::Omml.new('<mrow><mo>(</mo><mi>a</mi><mo>+</mo><mi>b</mi><mo>)</mo></mrow>')
    expect(omml).to be_a(Plurimath::Omml)
  end

  it 'returns Mathml instance' do
    omml = Plurimath::Omml.new('<mrow><mo>(</mo><mi>a</mi><mo>+</mo><mi>b</mi><mo>)</mo></mrow>')
    expect(omml.text).to eql('<mrow><mo>(</mo><mi>a</mi><mo>+</mo><mi>b</mi><mo>)</mo></mrow>')
  end
end
