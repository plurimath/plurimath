require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Gcd do

  it 'returns instance of Gcd' do
    gcd = Plurimath::Asciimath::Function::Gcd.new([70, 40])
    expect(gcd).to be_a(Plurimath::Asciimath::Function::Gcd)
  end

  it 'initializes Gcd object' do
    gcd = Plurimath::Asciimath::Function::Gcd.new([70, 40])
    expect(gcd.values).to eql([70, 40])
  end
end
