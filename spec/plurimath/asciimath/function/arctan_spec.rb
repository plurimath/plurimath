require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Arctan do

  it 'returns instance of Arctan' do
    arctan = Plurimath::Asciimath::Function::Arctan.new('70')
    expect(arctan).to be_a(Plurimath::Asciimath::Function::Arctan)
  end

  it 'initializes Arctan object' do
    arctan = Plurimath::Asciimath::Function::Arctan.new('70')
    expect(arctan.angle).to eql('70')
  end
end

