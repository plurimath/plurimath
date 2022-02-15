require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Sqrt do

  it 'returns instance of Sqrt' do
    sqrt = Plurimath::Asciimath::Function::Sqrt.new(70)
    expect(sqrt).to be_a(Plurimath::Asciimath::Function::Sqrt)
  end

  it 'initializes Sqrt object' do
    sqrt = Plurimath::Asciimath::Function::Sqrt.new(70)
    expect(sqrt.number).to eql(70)
  end
end
