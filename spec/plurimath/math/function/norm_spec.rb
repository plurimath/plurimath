require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Norm do

  it 'returns instance of Norm' do
    norm = Plurimath::Math::Function::Norm.new('70')
    expect(norm).to be_a(Plurimath::Math::Function::Norm)
  end

  it 'initializes Norm object' do
    norm = Plurimath::Math::Function::Norm.new('70')
    expect(norm.value).to eql('70')
  end
end
