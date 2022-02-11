require_relative '../../../lib/plurimath/asciimath_parser'

RSpec.describe Plurimath::AsciimathParser::Symbol do

  it 'returns instance of Symbol' do
    symbol = Plurimath::AsciimathParser::Symbol.new('symbol')
    expect(symbol).to be_a(Plurimath::AsciimathParser::Symbol)
  end

  it 'initializes Symbol object' do
    symbol = Plurimath::AsciimathParser::Symbol.new('symbol')
    expect(symbol.value).to eql('symbol')
  end
end
