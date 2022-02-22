require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Obrace do

  it 'returns instance of Obrace' do
    obrace = Plurimath::Math::Function::Obrace.new('70')
    expect(obrace).to be_a(Plurimath::Math::Function::Obrace)
  end

  it 'initializes Obrace object' do
    obrace = Plurimath::Math::Function::Obrace.new('70')
    expect(obrace.value).to eql('70')
  end
end
