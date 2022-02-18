require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Mathbf do

  it 'returns instance of Mathbf' do
    mathbf = Plurimath::Math::Function::Mathbf.new("AaBbCc")
    expect(mathbf).to be_a(Plurimath::Math::Function::Mathbf)
  end

  it 'initializes Mathbf object' do
    mathbf = Plurimath::Math::Function::Mathbf.new("AaBbCc")
    expect(mathbf.text).to eql("AaBbCc")
  end
end
