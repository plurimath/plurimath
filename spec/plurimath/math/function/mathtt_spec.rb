require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Mathtt do

  it 'returns instance of Mathtt' do
    mathtt = Plurimath::Math::Function::Mathtt.new("AaBbCc")
    expect(mathtt).to be_a(Plurimath::Math::Function::Mathtt)
  end

  it 'initializes Mathtt object' do
    mathtt = Plurimath::Math::Function::Mathtt.new("AaBbCc")
    expect(mathtt.parameter_one).to eql("AaBbCc")
  end
end
