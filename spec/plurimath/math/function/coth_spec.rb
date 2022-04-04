require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Coth do

  it 'returns instance of Coth' do
    coth = Plurimath::Math::Function::Coth.new('70')
    expect(coth).to be_a(Plurimath::Math::Function::Coth)
  end

  it 'initializes Coth object' do
    coth = Plurimath::Math::Function::Coth.new('70')
    expect(coth.parameter_one).to eql('70')
  end
end
