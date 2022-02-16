require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Mathbb do

  it 'returns instance of Mathbb' do
    mathbb = Plurimath::Asciimath::Function::Mathbb.new("AaBbCc")
    expect(mathbb).to be_a(Plurimath::Asciimath::Function::Mathbb)
  end

  it 'initializes Mathbb object' do
    mathbb = Plurimath::Asciimath::Function::Mathbb.new("AaBbCc")
    expect(mathbb.text).to eql("AaBbCc")
  end
end
