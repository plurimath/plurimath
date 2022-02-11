require_relative '../../../lib/plurimath/asciimath_parser'

RSpec.describe Plurimath::AsciimathParser::Tan do

  it 'returns instance of Tan' do
    tan = Plurimath::AsciimathParser::Tan.new('tan')
    expect(tan).to be_a(Plurimath::AsciimathParser::Tan)
  end

  it 'initializes Tan object' do
    tan = Plurimath::AsciimathParser::Tan.new('tan')
    expect(tan.angle).to eql('tan')
  end
end

