require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Mathfrak do

  it 'returns instance of Mathfrak' do
    mathfrak = Plurimath::Math::Function::Mathfrak.new("AaBbCc")
    expect(mathfrak).to be_a(Plurimath::Math::Function::Mathfrak)
  end

  it 'initializes Mathfrak object' do
    mathfrak = Plurimath::Math::Function::Mathfrak.new("AaBbCc")
    expect(mathfrak.text).to eql("AaBbCc")
  end
end
