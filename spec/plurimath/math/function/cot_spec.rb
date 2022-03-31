require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Cot do

  it 'returns instance of Cot' do
    cot = Plurimath::Math::Function::Cot.new('70')
    expect(cot).to be_a(Plurimath::Math::Function::Cot)
  end

  it 'initializes Cot object' do
    cot = Plurimath::Math::Function::Cot.new('70')
    expect(cot.parameter_one).to eql('70')
  end
end
