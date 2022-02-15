require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Cot do

  it 'returns instance of Cot' do
    cot = Plurimath::Asciimath::Function::Cot.new('70')
    expect(cot).to be_a(Plurimath::Asciimath::Function::Cot)
  end

  it 'initializes Cot object' do
    cot = Plurimath::Asciimath::Function::Cot.new('70')
    expect(cot.angle).to eql('70')
  end
end
