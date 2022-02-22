require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Cosh do

  it 'returns instance of Cosh' do
    cosh = Plurimath::Math::Function::Cosh.new('70')
    expect(cosh).to be_a(Plurimath::Math::Function::Cosh)
  end

  it 'initializes Cosh object' do
    cosh = Plurimath::Math::Function::Cosh.new('70')
    expect(cosh.angle).to eql('70')
  end
end
