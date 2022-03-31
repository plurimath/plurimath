require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Sqrt do

  it 'returns instance of Sqrt' do
    sqrt = Plurimath::Math::Function::Sqrt.new(70)
    expect(sqrt).to be_a(Plurimath::Math::Function::Sqrt)
  end

  it 'initializes Sqrt object' do
    sqrt = Plurimath::Math::Function::Sqrt.new(70)
    expect(sqrt.parameter_one).to eql(70)
  end
end
