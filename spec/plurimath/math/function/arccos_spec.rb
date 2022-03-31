require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Arccos do

  it 'returns instance of Arccos' do
    arccos = Plurimath::Math::Function::Arccos.new('70')
    expect(arccos).to be_a(Plurimath::Math::Function::Arccos)
  end

  it 'initializes Arccos object' do
    arccos = Plurimath::Math::Function::Arccos.new('70')
    expect(arccos.parameter_one).to eql('70')
  end
end
