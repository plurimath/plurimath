require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Latex do

  describe ".initialize" do
    subject(:latex) { described_class.new(string.gsub(/\s/, "")) }

    context "contains simple cos function with numeric value" do
      let(:string) { "\\cos_{45}" }
      it 'matches instance of Latex' do
        expect(latex).to be_a(Plurimath::Latex)
      end

      it 'matches text from Latex instance' do
        expect(latex.text).to eq('\\cos_{45}')
      end
    end
  end

  describe ".to_formula" do
    subject(:formula) { described_class.new(string.gsub(/\s/, "")).to_formula }

    context "contains basic simple Latex equation cos and numeric value" do
      let(:string) { '\\cos{45}' }
      it 'returns parsed Latex to Formula' do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Cos.new(
            Plurimath::Math::Number.new("45"),
          ),
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
