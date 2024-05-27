require "spec_helper"

RSpec.describe Plurimath::Math::Function::Text do

  describe ".initialize" do
    it 'returns instance of Text' do
      text = Plurimath::Math::Function::Text.new('Hello')
      expect(text).to be_a(Plurimath::Math::Function::Text)
    end

    it 'initializes Text object' do
      text = Plurimath::Math::Function::Text.new('Hello')
      expect(text.parameter_one).to eql('Hello')
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns asciimath string" do
        expect(formula).to eq("\"n\"")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns asciimath string" do
        expect(formula).to eq("\"70\"")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { "sum_(&)^(so)" }
      it "returns asciimath string" do
        expect(formula).to eq("\"sum_(&)^(so)\"")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value).
          to_mathml_without_math_tag(false),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { "unicode[:kappa]" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mtext>&#x3ba;</mtext>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "unitsml(kL)" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mtext>unitsml(kL)</mtext>")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { "sum_&^so" }

      it "returns mathml string" do
        expect(formula).to be_equivalent_to("<mtext>sum_&^so</mtext>")
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns mathml string" do
        expect(formula).to eql("\\text{n}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to eql("\\text{70}")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { "unicode[:kappa]" }
      it "returns mathml string" do
        expect(formula).to eql("\\text{kappa}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "returns mathml string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { "70" }

      it "returns mathml string" do
        expect(formula).to eql("70")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { "unicode[:kappa]" }
      it "returns mathml string" do
        expect(formula).to eql("&#x3ba;")
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
