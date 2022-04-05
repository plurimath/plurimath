require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Tanh do

  it 'returns instance of Tanh' do
    tanh = Plurimath::Math::Function::Tanh.new('70')
    expect(tanh).to be_a(Plurimath::Math::Function::Tanh)
  end

  it 'initializes Tanh object' do
    tanh = Plurimath::Math::Function::Tanh.new('70')
    expect(tanh.parameter_one).to eql('70')
  end
end
