require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Mathtt do

  it 'returns instance of Mathtt' do
    mathtt = Plurimath::Asciimath::Function::Mathtt.new("AaBbCc")
    expect(mathtt).to be_a(Plurimath::Asciimath::Function::Mathtt)
  end

  it 'initializes Mathtt object' do
    mathtt = Plurimath::Asciimath::Function::Mathtt.new("AaBbCc")
    expect(mathtt.text).to eql("AaBbCc")
  end
end
