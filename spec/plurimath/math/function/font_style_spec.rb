require "spec_helper"

RSpec.describe Plurimath::Math::Function::FontStyle do
  describe ".initialize" do
    it "returns instance of FontStyle" do
      font_style = described_class.new("AaBbCc")
      expect(font_style).to be_a(described_class)
    end

    it "initializes FontStyle object" do
      font_style = described_class.new("AaBbCc")
      expect(font_style.parameter_one).to eql("AaBbCc")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
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
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
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
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) { "bb" }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mstyle mathvariant="bold">
            <mi>n</mi>
          </mstyle>
        MATHML
        expect(formula).to be_xml_equivalent_to(expected_value)
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
        expect(formula).to be_xml_equivalent_to(expected_value)
      end
    end

    context "contains random value for font style" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Sum.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end
      let(:second_value) { "asf" }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mstyle mathvariant="asf">
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </mstyle>
        MATHML
        expect(formula).to be_xml_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
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
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end
      let(:second_value) { "cc" }

      it "returns mathml string" do
        expect(formula).to eql("\\sum_{\\&}^{\\text{so}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) { "frak" }

      it "returns html string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { "bold" }

      it "returns html string" do
        expect(formula).to eql("70")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Sum.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end
      let(:second_value) { "cc" }

      it "returns html string" do
        expect(formula).to eql("<i>&sum;</i><sub>&</sub><sup>so</sup>")
      end
    end
  end

  describe ".validate_function_formula" do
    subject(:formula) do
      described_class.new(first_value).validate_function_formula
    end

    context "contains Symbol as value" do
      let(:first_value) { "n" }

      it "expects true in return" do
        expect(formula).to be(true)
      end
    end

    context "contains Symbol as value" do
      let(:first_value) { "a" }

      it "does not return false" do
        expect(formula).not_to eql(false)
      end
    end
  end
end
