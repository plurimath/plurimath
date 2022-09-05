require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Unitsml do

  it 'returns instance of Unitsml' do
    unitsml = Plurimath::Unitsml.new('⎣2.5⎦')
    expect(unitsml).to be_a(Plurimath::Unitsml)
  end

  it 'returns Latex instance' do
    unitsml = Plurimath::Unitsml.new('⎣2.5⎦')
    expect(unitsml.text).to eql('⎣2.5⎦')
  end
end
