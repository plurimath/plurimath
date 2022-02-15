require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Ubrace do

  it 'returns instance of Ubrace' do
    ubrace = Plurimath::Asciimath::Function::Ubrace.new('70')
    expect(ubrace).to be_a(Plurimath::Asciimath::Function::Ubrace)
  end

  it 'initializes Ubrace object' do
    ubrace = Plurimath::Asciimath::Function::Ubrace.new('70')
    expect(ubrace.value).to eql('70')
  end
end
