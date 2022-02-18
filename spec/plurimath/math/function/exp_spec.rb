require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Exp do

  it 'returns instance of Exp' do
    exp = Plurimath::Math::Function::Exp.new('3')
    expect(exp).to be_a(Plurimath::Math::Function::Exp)
  end

  it 'initializes Exp object' do
    exp = Plurimath::Math::Function::Exp.new('3')
    expect(exp.exponent).to eql('3')
  end
end
