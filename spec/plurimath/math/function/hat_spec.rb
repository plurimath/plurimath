require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Hat do

  it 'returns instance of Hat' do
    hat = Plurimath::Math::Function::Hat.new('70')
    expect(hat).to be_a(Plurimath::Math::Function::Hat)
  end

  it 'initializes Hat object' do
    hat = Plurimath::Math::Function::Hat.new('70')
    expect(hat.value).to eql('70')
  end
end
