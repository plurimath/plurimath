require_relative '../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Symbol do

  it 'returns instance of Symbol' do
    symbol = Plurimath::Asciimath::Symbol.new('theta')
    expect(symbol).to be_a(Plurimath::Asciimath::Symbol)
  end

  it 'initializes Symbol object' do
    symbol = Plurimath::Asciimath::Symbol.new('theta')
    expect(symbol.value).to eql('theta')
  end
end
