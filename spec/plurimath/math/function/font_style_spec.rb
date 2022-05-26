require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::FontStyle do

  it 'returns instance of FontStyle' do
    font_style = Plurimath::Math::Function::FontStyle.new("AaBbCc")
    expect(font_style).to be_a(Plurimath::Math::Function::FontStyle)
  end

  it 'initializes FontStyle object' do
    font_style = Plurimath::Math::Function::FontStyle.new("AaBbCc")
    expect(font_style.parameter_one).to eql("AaBbCc")
  end
end
