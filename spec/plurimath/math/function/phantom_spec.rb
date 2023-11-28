require "spec_helper"

RSpec.describe Plurimath::Math::Function::Phantom do

  describe ".initialize" do
    it 'returns instance of Phantom' do
      phantom = Plurimath::Math::Function::Phantom.new('70')
      expect(phantom).to be_a(Plurimath::Math::Function::Phantom)
    end

    it 'initializes Phantom object' do
      phantom = Plurimath::Math::Function::Phantom.new('70')
      expect(phantom.parameter_one).to eql('70')
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns AsciiMath string" do
        expect(formula).to eq("\\ ")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns AsciiMath string" do
        expect(formula).to eq("\\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ ")
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
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns MathML string" do
        expected_value = <<~MATHML

          <mphantom>
            <mi>n</mi>
          </mphantom>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns MathML string" do
        expected_value = <<~MATHML

          <mphantom>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&#x26;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </mphantom>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns LaTeX string" do
        expect(formula).to eql("\\phantom{n}")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns LaTeX string" do
        expect(formula).to eql("\\phantom{\\sum_{&}^{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns HTML string" do
        expect(formula).to eql("<i style='visibility: hidden;'>n</i>")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns HTML string" do
        expect(formula).to eql("<i style='visibility: hidden;'><i>&sum;</i><sub>&</sub><sup>so</sup></i>")
      end
    end
  end
end
