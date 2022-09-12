require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Mathml do
  describe ".initialize" do
    subject(:formula) { described_class.new(mathml) }

    context "initialize Mathml object" do
      let(:mathml) { '<mrow><mn>2</mn></mrow>' }

      it 'returns instance of Mathml' do
        expect(formula).to be_a(Plurimath::Mathml)
      end

      it 'returns Mathml instance' do
        expect(formula.text).to eql('<mrow><mn>2</mn></mrow>')
      end
    end
  end

  describe ".to_formula" do
    subject(:formula) { described_class.new(string).to_formula }

    context "contains Mathml object" do
      let(:string)  { "<mrow><mn>2</mn></mrow>" }

      it 'returns Mathml string' do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2")
          ])
        ])
        expect(formula).to eq(expected_value)
      end

      it 'not returns Mathml string' do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
        expect(formula).not_to eq(expected_value)
      end
    end
  end
end
