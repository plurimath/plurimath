require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Gcd do

  it 'returns instance of Gcd' do
    gcd = Plurimath::Math::Function::Gcd.new([70, 40])
    expect(gcd).to be_a(Plurimath::Math::Function::Gcd)
  end

  it 'initializes Gcd object' do
    gcd = Plurimath::Math::Function::Gcd.new([70, 40])
    expect(gcd.parameter_one).to eql([70, 40])
  end
end
