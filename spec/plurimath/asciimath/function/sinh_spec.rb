require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Sinh do

  it 'returns instance of Sinh' do
    sinh = Plurimath::Asciimath::Function::Sinh.new('70')
    expect(sinh).to be_a(Plurimath::Asciimath::Function::Sinh)
  end

  it 'initializes Sinh object' do
    sinh = Plurimath::Asciimath::Function::Sinh.new('70')
    expect(sinh.angle).to eql('70')
  end
end
