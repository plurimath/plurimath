require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Coth do

  it 'returns instance of Coth' do
    coth = Plurimath::Asciimath::Function::Coth.new('70')
    expect(coth).to be_a(Plurimath::Asciimath::Function::Coth)
  end

  it 'initializes Coth object' do
    coth = Plurimath::Asciimath::Function::Coth.new('70')
    expect(coth.angle).to eql('70')
  end
end
