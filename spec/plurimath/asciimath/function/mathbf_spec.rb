require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Mathbf do

  it 'returns instance of Mathbf' do
    mathbf = Plurimath::Asciimath::Function::Mathbf.new("AaBbCc")
    expect(mathbf).to be_a(Plurimath::Asciimath::Function::Mathbf)
  end

  it 'initializes Mathbf object' do
    mathbf = Plurimath::Asciimath::Function::Mathbf.new("AaBbCc")
    expect(mathbf.text).to eql("AaBbCc")
  end
end
