require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Tanh do

  it 'returns instance of Tanh' do
    tanh = Plurimath::Asciimath::Function::Tanh.new('70')
    expect(tanh).to be_a(Plurimath::Asciimath::Function::Tanh)
  end

  it 'initializes Tanh object' do
    tanh = Plurimath::Asciimath::Function::Tanh.new('70')
    expect(tanh.angle).to eql('70')
  end
end
