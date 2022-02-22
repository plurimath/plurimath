require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Sech do

  it 'returns instance of Sech' do
    sech = Plurimath::Math::Function::Sech.new('70')
    expect(sech).to be_a(Plurimath::Math::Function::Sech)
  end

  it 'initializes Sech object' do
    sech = Plurimath::Math::Function::Sech.new('70')
    expect(sech.angle).to eql('70')
  end
end
