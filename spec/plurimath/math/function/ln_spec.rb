require "spec_helper"

RSpec.describe Plurimath::Math::Function::Ln do

  describe ".initialize" do
    it 'returns instance of Ln' do
      ln = Plurimath::Math::Function::Ln.new(45)
      expect(ln).to be_a(Plurimath::Math::Function::Ln)
    end

    it 'initializes Ln object' do
      ln = Plurimath::Math::Function::Ln.new(70)
      expect(ln.parameter_one).to eql(70)
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns asciimath string" do
        expect(formula).to eq("lnn")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("ln70")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns asciimath string" do
        expect(formula).to eq("lnsum_(&)^(\"so\")")
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
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expected_value = <<~MATHML

          <mrow>
            <mi>ln</mi>
            <mi>n</mi>
          </mrow>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mrow>
            <mi>ln</mi>
            <mn>70</mn>
          </mrow>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns mathml string" do
        expected_value = <<~MATHML
          <mrow>
            <mi>ln</mi>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </mrow>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("\\ln{n}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("\\ln{70}")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns mathml string" do
        expect(formula).to eql("\\ln{\\sum_{\\&}^{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("<i>ln</i><i>n</i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("<i>ln</i><i>70</i>")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns mathml string" do
        expect(formula).to eql("<i>ln</i><i><i>&sum;</i><sub>&</sub><sup>so</sup></i>")
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
