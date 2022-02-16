require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Mathsf do

  it 'returns instance of Mathsf' do
    mathsf = Plurimath::Asciimath::Function::Mathsf.new("AaBbCc")
    expect(mathsf).to be_a(Plurimath::Asciimath::Function::Mathsf)
  end

  it 'initializes Mathsf object' do
    mathsf = Plurimath::Asciimath::Function::Mathsf.new("AaBbCc")
    expect(mathsf.text).to eql("AaBbCc")
  end
end
