require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Omml do

  it 'returns instance of Omml' do
    omml = Omml.new('test.html')
    expect(omml).to be_a(Omml)
  end

  it 'returns Mathml instance' do
    omml = Omml.new('omml')
    expect(omml.text).to eql('omml')
  end
end
