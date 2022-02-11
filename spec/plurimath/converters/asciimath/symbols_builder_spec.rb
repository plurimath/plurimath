require_relative '../../../../lib/plurimath/converters/asciimath/parser'

RSpec.describe Plurimath::Math::SymbolsBuilder do

  it 'returns instance of SymbolsBuilder' do
    symbols_builder = Plurimath::Math::SymbolsBuilder.new('symbols_builder')
    expect(symbols_builder).to be_a(Plurimath::Math::SymbolsBuilder)
  end

  it 'initializes SymbolsBuilder object' do
    symbols_builder = Plurimath::Math::SymbolsBuilder.new('symbols_builder')
    expect(symbols_builder.value).to eql('symbols_builder')
  end
end
