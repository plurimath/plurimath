require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Arcsin do

  it 'returns instance of Arcsin' do
    arcsin = Plurimath::Math::Function::Arcsin.new('70')
    expect(arcsin).to be_a(Plurimath::Math::Function::Arcsin)
  end

  it 'initializes Arcsin object' do
    arcsin = Plurimath::Math::Function::Arcsin.new('70')
    expect(arcsin.angle).to eql('70')
  end
end

