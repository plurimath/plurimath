require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Arctan do

  it 'returns instance of Arctan' do
    arctan = Plurimath::Math::Function::Arctan.new('70')
    expect(arctan).to be_a(Plurimath::Math::Function::Arctan)
  end

  it 'initializes Arctan object' do
    arctan = Plurimath::Math::Function::Arctan.new('70')
    expect(arctan.angle).to eql('70')
  end
end

