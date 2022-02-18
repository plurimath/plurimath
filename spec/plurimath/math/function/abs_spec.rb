require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Abs do

  it 'returns instance of Abs' do
    abs = Plurimath::Math::Function::Abs.new('70')
    expect(abs).to be_a(Plurimath::Math::Function::Abs)
  end

  it 'initializes Abs object' do
    abs = Plurimath::Math::Function::Abs.new('70')
    expect(abs.value).to eql('70')
  end
end

