require_relative '../../../lib/plurimath/asciimath_parser'

RSpec.describe Plurimath::AsciimathParser::Cos do

  it 'returns instance of Cos' do
    cos = Plurimath::AsciimathParser::Cos.new('70')
    expect(cos).to be_a(Plurimath::AsciimathParser::Cos)
  end

  it 'initializes Cos object' do
    cos = Plurimath::AsciimathParser::Cos.new('70')
    expect(cos.angle).to eql('70')
  end
end

