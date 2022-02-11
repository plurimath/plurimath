require_relative '../../../lib/plurimath/asciimath_parser'

RSpec.describe Plurimath::AsciimathParser::SymbolsBuilder do

  it 'returns instance of SymbolsBuilder' do
    symbols_builder = Plurimath::AsciimathParser::SymbolsBuilder.new('symbols_builder')
    expect(symbols_builder).to be_a(Plurimath::AsciimathParser::SymbolsBuilder)
  end

  it 'initializes SymbolsBuilder object' do
    symbols_builder = Plurimath::AsciimathParser::SymbolsBuilder.new('symbols_builder')
    expect(symbols_builder.value).to eql('symbols_builder')
  end
end
