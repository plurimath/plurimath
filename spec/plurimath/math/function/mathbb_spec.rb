require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Mathbb do

  it 'returns instance of Mathbb' do
    mathbb = Plurimath::Math::Function::Mathbb.new("AaBbCc")
    expect(mathbb).to be_a(Plurimath::Math::Function::Mathbb)
  end

  it 'initializes Mathbb object' do
    mathbb = Plurimath::Math::Function::Mathbb.new("AaBbCc")
    expect(mathbb.parameter_one).to eql("AaBbCc")
  end
end
