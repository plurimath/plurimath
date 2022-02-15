require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Max do

  it 'returns instance of Max' do
    max = Plurimath::Asciimath::Function::Max.new([70, 4])
    expect(max).to be_a(Plurimath::Asciimath::Function::Max)
  end

  it 'initializes Max object' do
    max = Plurimath::Asciimath::Function::Max.new([70, 4])
    expect(max.values).to eql([70, 4])
  end
end
