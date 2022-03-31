require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Max do

  it 'returns instance of Max' do
    max = Plurimath::Math::Function::Max.new([70, 4])
    expect(max).to be_a(Plurimath::Math::Function::Max)
  end

  it 'initializes Max object' do
    max = Plurimath::Math::Function::Max.new([70, 4])
    expect(max.parameter_one).to eql([70, 4])
  end
end
