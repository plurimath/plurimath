require_relative '../../../lib/plurimath/asciimath_parser'

RSpec.describe Plurimath::AsciimathParser::Sin do

  it 'returns instance of Sin' do
    sin = Plurimath::AsciimathParser::Sin.new('70')
    expect(sin).to be_a(Plurimath::AsciimathParser::Sin)
  end

  it 'initializes Sin object' do
    sin = Plurimath::AsciimathParser::Sin.new('70')
    expect(sin.angle).to eql('70')
  end
end

