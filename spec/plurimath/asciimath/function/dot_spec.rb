require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Dot do

  it 'returns instance of Dot' do
    dot = Plurimath::Asciimath::Function::Dot.new('70')
    expect(dot).to be_a(Plurimath::Asciimath::Function::Dot)
  end

  it 'initializes Dot object' do
    dot = Plurimath::Asciimath::Function::Dot.new('70')
    expect(dot.value).to eql('70')
  end
end

