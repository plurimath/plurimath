require_relative '../../../lib/plurimath/asciimath_parser'

RSpec.describe Plurimath::AsciimathParser::Number do

  it 'returns instance of Number' do
    number = Plurimath::AsciimathParser::Number.new('number')
    expect(number).to be_a(Plurimath::AsciimathParser::Number)
  end

  it 'initializes Number object' do
    number = Plurimath::AsciimathParser::Number.new('number')
    expect(number.value).to eql('number')
  end
end
