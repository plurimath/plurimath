require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Norm do

  it 'returns instance of Norm' do
    norm = Plurimath::Asciimath::Function::Norm.new('70')
    expect(norm).to be_a(Plurimath::Asciimath::Function::Norm)
  end

  it 'initializes Norm object' do
    norm = Plurimath::Asciimath::Function::Norm.new('70')
    expect(norm.value).to eql('70')
  end
end
