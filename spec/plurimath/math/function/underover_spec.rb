require "spec_helper"

RSpec.describe Plurimath::Math::Function::Underover do

  describe ".initialize" do
    it 'returns instance of Underover' do
      underover = Plurimath::Math::Function::Underover.new("sum", "theta", "square")
      expect(underover).to be_a(Plurimath::Math::Function::Underover)
    end

    it 'initializes Underover object' do
      underover = Plurimath::Math::Function::Underover.new("sum", "theta", "square")
      expect(underover.parameter_one).to eql("sum")
      expect(underover.parameter_two).to eql("theta")
      expect(underover.parameter_three).to eql("square")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value, second_value, third_value).to_asciimath }

    context "contains Symbol Unicode and Number as values" do
      let(:first_value)  { Plurimath::Math::Unicode.new("&#x2211;") }
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("&#x2211;_(-)^(70)")
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
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("(sum_(&)^(\"so\"))_(-)^(70)")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value, third_value).
          to_mathml_without_math_tag,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value)  { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <munderover>
            <mi>n</mi>
            <mo>&#x2212;</mo>
            <mn>70</mn>
          </munderover>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value)  { Plurimath::Math::Unicode.new("&#x2211;") }
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <munderover>
            <mo>&#x2211;</mo>
            <mo>&#x2212;</mo>
            <mn>70</mn>
          </munderover>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
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
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2211;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <munderover>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&#x26;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mo>&#x2211;</mo>
            <mn>70</mn>
          </munderover>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value, second_value, third_value).to_latex }

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns latex string" do
        expect(formula).to eql("{\\sum_{&}^{\\text{so}}}_{-}^{70}")
      end
    end

    context "contains Unicode as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("&#x2211;") }
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns latex string" do
        expect(formula).to eql("&#x2211;_{-}^{70}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("80") }
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns latex string" do
        expect(formula).to eql("80_{-}^{70}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value, second_value, third_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns html string" do
        expect(formula).to eql("<i>n</i><i>&#x2212;</i><i>70</i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Symbol.new("n") }

      it "returns html string" do
        expect(formula).to eql("<i>70</i><i>&#x2212;</i><i>n</i>")
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
      let(:second_value) { Plurimath::Math::Symbol.new("&#x2212;") }
      let(:third_value)  { Plurimath::Math::Number.new("70") }

      it "returns html string" do
        expect(formula).to eql("<i><i>&sum;</i><sub>&</sub><sup>so</sup></i><i>&#x2212;</i><i>70</i>")
      end
    end
  end
end
