require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Csc do

  it 'returns instance of Csc' do
    csc = Plurimath::Asciimath::Function::Csc.new('70')
    expect(csc).to be_a(Plurimath::Asciimath::Function::Csc)
  end

  it 'initializes Csc object' do
    csc = Plurimath::Asciimath::Function::Csc.new('70')
    expect(csc.angle).to eql('70')
  end
end
