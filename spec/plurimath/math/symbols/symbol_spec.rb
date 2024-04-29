require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Symbol do

  describe ".initialize" do
    it 'returns instance of Symbol' do
      symbol = described_class.new('theta')
      expect(symbol).to be_a(described_class)
    end

    it 'initializes Symbol object' do
      symbol = described_class.new('theta')
      expect(symbol.value).to eql('theta')
    end
  end

  describe ".==" do
    subject(:symbol) { described_class.new(value) }

    context "contains a symbol string" do
      let(:value) { "gamma" }
      expected_value = described_class.new("gamma")

      it 'returns string' do
        expect(symbol == expected_value).to be_truthy
      end
    end

    context "contains a nil string" do
      let(:value) { "" }
      expected_value = described_class.new("Gamma")

      it 'returns string' do
        expect(symbol == expected_value).to be_falsey
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns asciimath string" do
        expect(formula).to eq("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns asciimath string" do
        expect(formula).to eq("70")
      end
    end

    context "contains Unicode as value" do
      let(:first_value) { "&#x2212;" }
      it "returns asciimath string" do
        expect(formula).to eq("&#x2212;")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value).
          to_mathml_without_math_tag,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mi>n</mi>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mi>70</mi>")
      end
    end

    context "contains Function name as value" do
      let(:first_value) { "sum" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mi>sum</mi>")
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns latex string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns latex string" do
        expect(formula).to eql("70")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { "sum" }
      it "returns latex string" do
        expect(formula).to eql("sum")
      end
    end
  end

  describe ".to_omml" do
    subject(:formula) { described_class.new(first_value).to_omml_without_math_tag(true).gsub("&amp;", "&") }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns omml string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns omml string" do
        expect(formula).to eql("70")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { "sum" }
      it "returns omml string" do
        expect(formula).to eql("sum")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns html string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns html string" do
        expect(formula).to eql("70")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { "&sum;" }

      it "returns html string" do
        expect(formula).to eql("&sum;")
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
