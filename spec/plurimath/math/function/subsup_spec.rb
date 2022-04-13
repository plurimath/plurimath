require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Subsup do

  it 'returns instance of Subsup' do
    subsup = Plurimath::Math::Function::Subsup.new(7)
    expect(subsup).to be_a(Plurimath::Math::Function::Subsup)
  end

  it 'initializes Subsup object' do
    subsup = Plurimath::Math::Function::Subsup.new(70)
    expect(subsup.parameter_one).to eql(70)
  end
end
