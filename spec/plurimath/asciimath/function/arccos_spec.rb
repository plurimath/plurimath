require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Arccos do

  it 'returns instance of Arccos' do
    arccos = Plurimath::Asciimath::Function::Arccos.new('70')
    expect(arccos).to be_a(Plurimath::Asciimath::Function::Arccos)
  end

  it 'initializes Arccos object' do
    arccos = Plurimath::Asciimath::Function::Arccos.new('70')
    expect(arccos.angle).to eql('70')
  end
end
