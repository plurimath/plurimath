require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Mod do

  it 'returns instance of Mod' do
    mod = Plurimath::Math::Function::Mod.new(70, 3)
    expect(mod).to be_a(Plurimath::Math::Function::Mod)
  end

  it 'initializes Mod object' do
    mod = Plurimath::Math::Function::Mod.new(70, 3)
    expect(mod.dividend).to eql(70)
    expect(mod.divisor).to eql(3)
  end
end
