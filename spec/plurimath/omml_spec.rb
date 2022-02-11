require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath::Omml do

  it 'returns instance of Omml' do
    omml = Plurimath::Omml.new('test.html')
    expect(omml).to be_a(Plurimath::Omml)
  end

  it 'returns Mathml instance' do
    omml = Plurimath::Omml.new('omml')
    expect(omml.text).to eql('omml')
  end
end
