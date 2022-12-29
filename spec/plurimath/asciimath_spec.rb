require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Asciimath do
  describe ".initialize" do
    subject(:asciimath) { Plurimath::Asciimath.new(string.gsub(/\s/, "")) }

    context "contains simple cos function with numeric value" do
      let(:string) { "cos(2)" }
      it 'returns instance of Asciimath' do
        expect(asciimath).to be_a(Plurimath::Asciimath)
      end

      it 'initializes Plurimath::Asciimath object' do
        expect(asciimath.text).to eql('cos(2)')
      end
    end
  end

  describe ".to_formula" do
    subject(:formula) { Plurimath::Asciimath.new(string.gsub(/\s/, "")).to_formula }

    context "contains basic simple asciimath equation cos and numeric value" do
      let(:string) { 'cos(2)' }
      it 'returns parsed Asciimath to Formula' do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Number.new("2"),
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
