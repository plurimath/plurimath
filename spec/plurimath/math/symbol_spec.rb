require_relative '../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Symbol do

  it 'returns instance of Symbol' do
    symbol = Plurimath::Math::Symbol.new('theta')
    expect(symbol).to be_a(Plurimath::Math::Symbol)
  end

  it 'initializes Symbol object' do
    symbol = Plurimath::Math::Symbol.new('theta')
    expect(symbol.value).to eql('theta')
  end
end
