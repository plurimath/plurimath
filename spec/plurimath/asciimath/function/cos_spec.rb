require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Cos do

  it 'returns instance of Cos' do
    cos = Plurimath::Asciimath::Function::Cos.new('70')
    expect(cos).to be_a(Plurimath::Asciimath::Function::Cos)
  end

  it 'initializes Cos object' do
    cos = Plurimath::Asciimath::Function::Cos.new('70')
    expect(cos.angle).to eql('70')
  end
end

