require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::F do

  it 'returns instance of F' do
    f = Plurimath::Math::Function::F.new('70')
    expect(f).to be_a(Plurimath::Math::Function::F)
  end

  it 'initializes F object' do
    f = Plurimath::Math::Function::F.new('70')
    expect(f.value).to eql('70')
  end
end
