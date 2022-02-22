require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Csc do

  it 'returns instance of Csc' do
    csc = Plurimath::Math::Function::Csc.new('70')
    expect(csc).to be_a(Plurimath::Math::Function::Csc)
  end

  it 'initializes Csc object' do
    csc = Plurimath::Math::Function::Csc.new('70')
    expect(csc.angle).to eql('70')
  end
end
