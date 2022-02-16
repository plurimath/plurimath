require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Mathfrak do

  it 'returns instance of Mathfrak' do
    mathfrak = Plurimath::Asciimath::Function::Mathfrak.new("AaBbCc")
    expect(mathfrak).to be_a(Plurimath::Asciimath::Function::Mathfrak)
  end

  it 'initializes Mathfrak object' do
    mathfrak = Plurimath::Asciimath::Function::Mathfrak.new("AaBbCc")
    expect(mathfrak.text).to eql("AaBbCc")
  end
end
