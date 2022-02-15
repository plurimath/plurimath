require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Mod do

  it 'returns instance of Mod' do
    mod = Plurimath::Asciimath::Function::Mod.new(70, 3)
    expect(mod).to be_a(Plurimath::Asciimath::Function::Mod)
  end

  it 'initializes Mod object' do
    mod = Plurimath::Asciimath::Function::Mod.new(70, 3)
    expect(mod.dividend).to eql(70)
    expect(mod.divisor).to eql(3)
  end
end
