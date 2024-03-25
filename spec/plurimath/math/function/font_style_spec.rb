require "spec_helper"

RSpec.describe Plurimath::Math::Function::FontStyle do

  describe ".initialize" do
    it 'returns instance of FontStyle' do
      font_style = Plurimath::Math::Function::FontStyle.new("AaBbCc")
      expect(font_style).to be_a(Plurimath::Math::Function::FontStyle)
    end

    it 'initializes FontStyle object' do
      font_style = Plurimath::Math::Function::FontStyle.new("AaBbCc")
      expect(font_style.parameter_one).to eql("AaBbCc")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value, second_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { "mathbb" }

      it "returns asciimath string" do
        expect(formula).to eq("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { "fr" }

      it "returns asciimath string" do
        expect(formula).to eq("70")
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
      let(:second_value) { "mathtt" }

      it "returns asciimath string" do
        expect(formula).to eq("sum_(&)^(\"so\")")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value).
          to_mathml_without_math_tag,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { "bb" }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mstyle mathvariant="bold">
            <mi>n</mi>
          </mstyle>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { "monospace" }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mstyle mathvariant="monospace">
            <mn>70</mn>
          </mstyle>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains random value for font style" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      let(:second_value) { "asf" }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mstyle mathvariant="asf">
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&#x26;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </mstyle>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value, second_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { "cc" }

      it "returns mathml string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { "fr" }

      it "returns mathml string" do
        expect(formula).to eql("70")
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
      let(:second_value) { "cc" }

      it "returns mathml string" do
        expect(formula).to eql("\\sum_{&}^{\\text{so}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value, second_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { "frak" }

      it "returns mathml string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { "bold" }

      it "returns mathml string" do
        expect(formula).to eql("70")
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
      let(:second_value) { "cc" }

      it "returns mathml string" do
        expect(formula).to eql("<i>&sum;</i><sub>&</sub><sup>so</sup>")
      end
    end
  end

  describe ".validate_function_formula" do
    subject(:formula) { described_class.new(first_value).validate_function_formula }

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "expects true in return" do
        expect(formula).to eql(true)
      end
    end

    context "contains Symbol as value" do
      let(:first_value) { "a" }

      it "should not return false" do
        expect(formula).not_to eql(false)
      end
    end
  end
end
