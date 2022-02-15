require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::F do

  it 'returns instance of F' do
    f = Plurimath::Asciimath::Function::F.new('70')
    expect(f).to be_a(Plurimath::Asciimath::Function::F)
  end

  it 'initializes F object' do
    f = Plurimath::Asciimath::Function::F.new('70')
    expect(f.value).to eql('70')
  end
end
