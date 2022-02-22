require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Text do

  it 'returns instance of Text' do
    texr = Plurimath::Math::Function::Text.new('Hello')
    expect(texr).to be_a(Plurimath::Math::Function::Text)
  end

  it 'initializes Text object' do
    texr = Plurimath::Math::Function::Text.new('Hello')
    expect(texr.string).to eql('Hello')
  end
end
