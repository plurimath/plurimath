require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Ubrace do

  it 'returns instance of Ubrace' do
    ubrace = Plurimath::Math::Function::Ubrace.new('70')
    expect(ubrace).to be_a(Plurimath::Math::Function::Ubrace)
  end

  it 'initializes Ubrace object' do
    ubrace = Plurimath::Math::Function::Ubrace.new('70')
    expect(ubrace.value).to eql('70')
  end
end
