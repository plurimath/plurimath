require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Mathml do

  it 'returns instance of Mathml' do
    mathml = Mathml.new('mathml')
    expect(mathml).to be_a(Mathml)
  end

  it 'returns Asciimath instance' do
    mathml = Mathml.new('mathml')
    expect(mathml.text).to eql('mathml')
  end
end
