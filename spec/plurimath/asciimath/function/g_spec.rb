require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::G do

  it 'returns instance of G' do
    g = Plurimath::Asciimath::Function::G.new('70')
    expect(g).to be_a(Plurimath::Asciimath::Function::G)
  end

  it 'initializes G object' do
    g = Plurimath::Asciimath::Function::G.new('70')
    expect(g.value).to eql('70')
  end
end
