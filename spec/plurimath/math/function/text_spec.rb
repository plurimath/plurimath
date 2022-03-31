require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Text do

  it 'returns instance of Text' do
    text = Plurimath::Math::Function::Text.new('Hello')
    expect(text).to be_a(Plurimath::Math::Function::Text)
  end

  it 'initializes Text object' do
    text = Plurimath::Math::Function::Text.new('Hello')
    expect(text.parameter_one).to eql('Hello')
  end
end
