require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::G do

  it 'returns instance of G' do
    g = Plurimath::Math::Function::G.new('70')
    expect(g).to be_a(Plurimath::Math::Function::G)
  end

  it 'initializes G object' do
    g = Plurimath::Math::Function::G.new('70')
    expect(g.parameter_one).to eql('70')
  end
end
