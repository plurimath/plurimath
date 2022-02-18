require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Frac do

  it 'returns instance of Frac' do
    frac = Plurimath::Math::Function::Frac.new(7, 3)
    expect(frac).to be_a(Plurimath::Math::Function::Frac)
  end

  it 'initializes Frac object' do
    frac = Plurimath::Math::Function::Frac.new(7, 4)
    expect(frac.dividend).to eql(7)
    expect(frac.divisor).to eql(4)
  end
end
