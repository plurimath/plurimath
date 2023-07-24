require_relative '../../../../spec/spec_helper'

RSpec.describe Plurimath::Math::Function::Left do

  describe ".initialize" do
    subject(:left) { described_class.new(string)  }

    context "contains simple text to match Object and field value" do

      it 'returns instance of Left' do
        left = Plurimath::Math::Function::Left.new('70')
        expect(left).to be_a(Plurimath::Math::Function::Left)
      end

      it 'initializes Left object' do
        left = Plurimath::Math::Function::Left.new('70')
        expect(left.parameter_one).to eql('70')
      end
    end
  end

  describe ".to_asciimath" do
    subject(:left) { described_class.new(string).to_asciimath  }

    context "contains opening bracket" do
      let(:string) { "(" }

      it 'returns instance of Left' do
        expect(left).to eq("left(")
      end
    end
  end

  describe ".to_latex" do
    subject(:left) { described_class.new(string).to_latex  }

    context "contains opening bracket" do
      let(:string) { "(" }

      it 'returns instance of Left' do
        expect(left).to eq("\\left (")
      end
    end

    context "contains curly opening bracket" do
      let(:string) { "{" }

      it 'returns instance of Left' do
        expect(left).to eq("\\left \\{")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Ox.dump(
        described_class.new(first_value).
          to_mathml_without_math_tag,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { "(" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mo>(</mo>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "{" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mo>{</mo>")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { "[" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mo>[</mo>")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { "(" }

      it "returns mathml string" do
        expect(formula).to eql("<i>(</i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "{" }

      it "returns mathml string" do
        expect(formula).to eql("<i>{</i>")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { "[" }

      it "returns mathml string" do
        expect(formula).to eql("<i>[</i>")
      end
    end
  end

  describe ".validate_function_formula" do
    subject(:formula) { described_class.new(first_value).validate_function_formula }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "expects false in return" do
        expect(formula).to eql(false)
      end
    end

    context "contains Symbol as value" do
      let(:first_value) { "a" }

      it "should not return true" do
        expect(formula).not_to eql(true)
      end
    end
  end
end
