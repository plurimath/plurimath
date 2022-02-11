require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath::Mathml do

  it 'returns instance of Mathml' do
    mathml = Plurimath::Mathml.new('mathml')
    expect(mathml).to be_a(Plurimath::Mathml)
  end

  it 'returns Asciimath instance' do
    mathml = Plurimath::Mathml.new('mathml')
    expect(mathml.text).to eql('mathml')
  end
end
