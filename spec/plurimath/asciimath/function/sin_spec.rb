require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Sin do

  it 'returns instance of Sin' do
    sin = Plurimath::Asciimath::Function::Sin.new('70')
    expect(sin).to be_a(Plurimath::Asciimath::Function::Sin)
  end

  it 'initializes Sin object' do
    sin = Plurimath::Asciimath::Function::Sin.new('70')
    expect(sin.angle).to eql('70')
  end
end

