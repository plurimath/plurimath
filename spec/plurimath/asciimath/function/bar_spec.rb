require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Bar do

  it 'returns instance of Bar' do
    bar = Plurimath::Asciimath::Function::Bar.new('70')
    expect(bar).to be_a(Plurimath::Asciimath::Function::Bar)
  end

  it 'initializes Bar object' do
    bar = Plurimath::Asciimath::Function::Bar.new('70')
    expect(bar.value).to eql('70')
  end
end

