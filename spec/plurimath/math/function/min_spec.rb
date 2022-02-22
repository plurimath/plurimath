require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Min do

  it 'returns instance of Min' do
    min = Plurimath::Math::Function::Min.new([70, 3])
    expect(min).to be_a(Plurimath::Math::Function::Min)
  end

  it 'initializes Min object' do
    min = Plurimath::Math::Function::Min.new([70, 3])
    expect(min.values).to eql([70, 3])
  end
end
