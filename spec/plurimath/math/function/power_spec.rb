require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Stackrel do

  it 'returns instance of Stackrel' do
    stackrel = Plurimath::Math::Function::Stackrel.new(7, 70)
    expect(stackrel).to be_a(Plurimath::Math::Function::Stackrel)
  end

  it 'initializes Stackrel object' do
    stackrel = Plurimath::Math::Function::Stackrel.new(70, 7)
    expect(stackrel.base).to eql(70)
    expect(stackrel.exponent).to eql(7)
  end
end
