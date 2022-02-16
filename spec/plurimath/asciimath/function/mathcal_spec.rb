require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Mathcal do

  it 'returns instance of Mathcal' do
    mathcal = Plurimath::Asciimath::Function::Mathcal.new("AaBbCc")
    expect(mathcal).to be_a(Plurimath::Asciimath::Function::Mathcal)
  end

  it 'initializes Mathcal object' do
    mathcal = Plurimath::Asciimath::Function::Mathcal.new("AaBbCc")
    expect(mathcal.text).to eql("AaBbCc")
  end
end
