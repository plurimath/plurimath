require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Mathsf do

  it 'returns instance of Mathsf' do
    mathsf = Plurimath::Math::Function::Mathsf.new("AaBbCc")
    expect(mathsf).to be_a(Plurimath::Math::Function::Mathsf)
  end

  it 'initializes Mathsf object' do
    mathsf = Plurimath::Math::Function::Mathsf.new("AaBbCc")
    expect(mathsf.parameter_one).to eql("AaBbCc")
  end
end
