require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Arcsin do

  it 'returns instance of Arcsin' do
    arcsin = Plurimath::Asciimath::Function::Arcsin.new('70')
    expect(arcsin).to be_a(Plurimath::Asciimath::Function::Arcsin)
  end

  it 'initializes Arcsin object' do
    arcsin = Plurimath::Asciimath::Function::Arcsin.new('70')
    expect(arcsin.angle).to eql('70')
  end
end

