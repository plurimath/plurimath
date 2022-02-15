require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Hat do

  it 'returns instance of Hat' do
    hat = Plurimath::Asciimath::Function::Hat.new('70')
    expect(hat).to be_a(Plurimath::Asciimath::Function::Hat)
  end

  it 'initializes Hat object' do
    hat = Plurimath::Asciimath::Function::Hat.new('70')
    expect(hat.value).to eql('70')
  end
end
