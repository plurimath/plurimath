require_relative '../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Number do

  it 'returns instance of Number' do
    number = Plurimath::Math::Number.new(100)
    expect(number).to be_a(Plurimath::Math::Number)
  end

  it 'initializes Number object' do
    number = Plurimath::Math::Number.new(100)
    expect(number.value).to eql(100)
  end

  describe ".to_asciimath" do
    subject(:number) { Plurimath::Math::Number.new(value) }

    context "contains a number string" do
      let(:value) { "1" }
      it 'returns string' do
        expect(number.to_asciimath).to eq(value)
      end
    end
  end

  describe ".==" do
    subject(:number) { Plurimath::Math::Number.new(value) }

    context "contains a number string" do
      let(:value) { "1" }
      expected_value = Plurimath::Math::Number.new("1")

      it 'returns string' do
        expect(number == expected_value).to be_truthy
      end
    end

    context "contains a nil string" do
      let(:value) { "" }
      expected_value = Plurimath::Math::Number.new("1")

      it 'returns string' do
        expect(number == expected_value).to be_falsey
      end
    end
  end
end
