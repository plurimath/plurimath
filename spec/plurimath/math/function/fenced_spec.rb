require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Fenced do

  describe ".initialize" do
    subject(:fenced) { Plurimath::Math::Function::Fenced.new(first, second, third) }

    context "initialize fenced object" do
      let(:first) { "sum" }
      let(:second) { "theta" }
      let(:third) { "square" }

      it 'returns instance of Fenced object' do
        expect(fenced).to be_a(Plurimath::Math::Function::Fenced)
      end

      it 'initialized Fenced object values' do
        expect(fenced.parameter_one).to eql("sum")
        expect(fenced.parameter_two).to eql("theta")
        expect(fenced.parameter_three).to eql("square")
      end
    end
  end

  describe ".to_asciimath" do
    subject(:fenced) { Plurimath::Math::Function::Fenced.new(first, second, third).to_asciimath }

    context "contains fenced object with default braces" do
      let(:first) { Plurimath::Math::Symbol.new("(") }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { Plurimath::Math::Symbol.new(")") }
      it "returns asciimath string" do
        expected_value = "(sum)"
        expect(fenced).to eq(expected_value)
      end
    end

    context "contains fenced object with curly braces" do
      let(:first) { Plurimath::Math::Symbol.new("{") }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { Plurimath::Math::Symbol.new("}") }
      it "returns asciimath string" do
        expected_value = "{sum}"
        expect(fenced).to eq(expected_value)
      end
    end

    context "contains fenced object with single curly braces" do
      let(:first) { nil }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { Plurimath::Math::Symbol.new("}") }
      it "matches with expected value" do
        expected_value = "(sum}"
        expect(fenced).to eq(expected_value)
      end
    end

    context "contains fenced object with curly braces" do
      let(:first) { Plurimath::Math::Symbol.new("{") }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { nil }
      it "does not match" do
        expected_value = "{sum"
        expect(fenced).not_to eq(expected_value)
      end
    end
  end

  describe ".==" do
    subject(:fenced) { Plurimath::Math::Function::Fenced.new(first, second, third) }

    context "contains fenced object with default braces" do
      let(:first) { Plurimath::Math::Symbol.new("(") }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { Plurimath::Math::Symbol.new(")") }
      it "returns true" do
        expected_value = Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [Plurimath::Math::Function::Sum.new],
          Plurimath::Math::Symbol.new(")"),
        )
        expect(fenced).to eq(expected_value)
      end
    end

    context "contains fenced object with curly braces" do
      let(:first) { Plurimath::Math::Symbol.new("{") }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { Plurimath::Math::Symbol.new("}") }
      it "returns false" do
        expected_value = Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbol.new(")"),
        )
        expect(fenced).not_to eq(expected_value)
      end
    end
  end
end
