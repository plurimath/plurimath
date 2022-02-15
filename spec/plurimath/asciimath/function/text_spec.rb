require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Text do

  it 'returns instance of Text' do
    texr = Plurimath::Asciimath::Function::Text.new('Hello')
    expect(texr).to be_a(Plurimath::Asciimath::Function::Text)
  end

  it 'initializes Text object' do
    texr = Plurimath::Asciimath::Function::Text.new('Hello')
    expect(texr.string).to eql('Hello')
  end
end
