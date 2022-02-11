require_relative '../../../../lib/plurimath/converters/asciimath/parser'

RSpec.describe Plurimath::Math::Symbol do

  it 'returns instance of Symbol' do
    symbol = Plurimath::Math::Symbol.new('symbol')
    expect(symbol).to be_a(Plurimath::Math::Symbol)
  end

  it 'initializes Symbol object' do
    symbol = Plurimath::Math::Symbol.new('symbol')
    expect(symbol.value).to eql('symbol')
  end
end
