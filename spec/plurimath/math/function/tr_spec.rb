require_relative '../../../../lib/plurimath/math'

RSpec.describe Plurimath::Math::Function::Tr do

  it 'returns instance of Tr' do
    tr = Plurimath::Math::Function::Tr.new('70')
    expect(tr).to be_a(Plurimath::Math::Function::Tr)
  end

  it 'initializes Tr object' do
    tr = Plurimath::Math::Function::Tr.new('70')
    expect(tr.parameter_one).to eql('70')
  end
end
