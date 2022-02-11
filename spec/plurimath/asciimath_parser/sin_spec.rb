require_relative '../../../lib/plurimath/asciimath_parser'

RSpec.describe Plurimath::AsciimathParser::Sin do

  it 'returns instance of Sin' do
    sin = Plurimath::AsciimathParser::Sin.new('sin')
    expect(sin).to be_a(Plurimath::AsciimathParser::Sin)
  end

  it 'initializes Sin object' do
    sin = Plurimath::AsciimathParser::Sin.new('sin')
    expect(sin.angle).to eql('sin')
  end
end

