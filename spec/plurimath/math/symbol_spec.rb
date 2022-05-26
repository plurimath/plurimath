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

  describe ".to_asciimath" do
    subject(:symbol) { Plurimath::Math::Symbol.new(value) }

    context "contains a symbol string" do
      let(:value) { "Theta" }
      it 'returns string' do
        expect(symbol.to_asciimath).to eq(value)
      end
    end
  end

  describe ".==" do
    subject(:symbol) { Plurimath::Math::Symbol.new(value) }

    context "contains a symbol string" do
      let(:value) { "gamma" }
      expected_value = Plurimath::Math::Symbol.new("gamma")

      it 'returns string' do
        expect(symbol == expected_value).to be_truthy
      end
    end

    context "contains a nil string" do
      let(:value) { "" }
      expected_value = Plurimath::Math::Symbol.new("Gamma")

      it 'returns string' do
        expect(symbol == expected_value).to be_falsey
      end
    end
  end
end
