require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Dot do

  it 'returns instance of Dot' do
    dot = Plurimath::Math::Function::Dot.new('70')
    expect(dot).to be_a(Plurimath::Math::Function::Dot)
  end

  it 'initializes Dot object' do
    dot = Plurimath::Math::Function::Dot.new('70')
    expect(dot.parameter_one).to eql('70')
  end
end
