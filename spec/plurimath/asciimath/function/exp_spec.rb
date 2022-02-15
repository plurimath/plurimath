require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Exp do

  it 'returns instance of Exp' do
    exp = Plurimath::Asciimath::Function::Exp.new('3')
    expect(exp).to be_a(Plurimath::Asciimath::Function::Exp)
  end

  it 'initializes Exp object' do
    exp = Plurimath::Asciimath::Function::Exp.new('3')
    expect(exp.exponent).to eql('3')
  end
end
