require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Mathcal do

  it 'returns instance of Mathcal' do
    mathcal = Plurimath::Math::Function::Mathcal.new("AaBbCc")
    expect(mathcal).to be_a(Plurimath::Math::Function::Mathcal)
  end

  it 'initializes Mathcal object' do
    mathcal = Plurimath::Math::Function::Mathcal.new("AaBbCc")
    expect(mathcal.text).to eql("AaBbCc")
  end
end
