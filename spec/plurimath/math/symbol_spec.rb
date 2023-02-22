require_relative '../../../spec/spec_helper'

RSpec.describe Plurimath::Math::Symbol do

  describe ".initialize" do
    it 'returns instance of Symbol' do
      symbol = Plurimath::Math::Symbol.new('theta')
      expect(symbol).to be_a(Plurimath::Math::Symbol)
    end

    it 'initializes Symbol object' do
      symbol = Plurimath::Math::Symbol.new('theta')
      expect(symbol.value).to eql('theta')
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
        expect(formula).to eq("-")
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
        expect(formula).to be_equivalent_to("<mo>&#x2211;</mo>")
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
    subject(:formula) { described_class.new(first_value).to_omml_without_math_tag.gsub("&amp;", "&") }

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
end
