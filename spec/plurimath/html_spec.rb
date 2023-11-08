require "spec_helper"

RSpec.describe Plurimath::Html do

  describe ".initialize" do
    subject(:formula) { described_class.new(string.gsub(/\s/, "")) }

    context "matches class naem and text" do
      let(:string) { '<h4> 1 + 3 </h4>' }
      it 'matches the class object' do
        expect(formula).to be_a(Plurimath::Html)
      end

      it 'contains passed html string' do
        expect(formula.text).to eq(string.gsub(/\s/, ""))
      end
    end
  end

  describe ".to_formula" do
    subject(:formula) { described_class.new(string.gsub(/\s/, "")).to_formula }

    context "contains basic simple html math equation and" do
      let(:string) { '<h4> 1 + 3 </h4>' }
      it 'returns parsed HTML to Formula' do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Number.new("1"),
          Plurimath::Math::Symbol.new("+"),
          Plurimath::Math::Number.new("3")
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
