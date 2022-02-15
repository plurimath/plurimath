require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Color do

  it 'returns instance of Color' do
    color = Plurimath::Asciimath::Function::Color.new('red', '70')
    expect(color).to be_a(Plurimath::Asciimath::Function::Color)
  end

  it 'initializes Color object' do
    color = Plurimath::Asciimath::Function::Color.new('red', '70')
    expect(color.color).to eql('red')
    expect(color.value).to eql('70')
  end
end
