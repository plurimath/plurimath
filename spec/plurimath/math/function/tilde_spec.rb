require_relative '../../../../spec/spec_helper'

RSpec.describe Plurimath::Math::Function::Tilde do

  describe ".initialize" do
    it 'returns instance of Tilde' do
      tilde = Plurimath::Math::Function::Tilde.new('70')
      expect(tilde).to be_a(Plurimath::Math::Function::Tilde)
    end

    it 'initializes Tilde object' do
      tilde = Plurimath::Math::Function::Tilde.new('70')
      expect(tilde.parameter_one).to eql('70')
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns asciimath string" do
        expect(formula).to eq("tilde(n)")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("tilde(70)")
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
      it "returns asciimath string" do
        expect(formula).to eq("tilde(sum_(&)^(\"so\"))")
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
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mover>
            <mi>n</mi>
            <mo>~</mo>
          </mover>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mover>
            <mn>70</mn>
            <mo>~</mo>
          </mover>
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
      it "returns mathml string" do
        expected_value = <<~MATHML
          <mover>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&amp;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mo>~</mo>
          </mover>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("\\tilde{n}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("\\tilde{70}")
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
      it "returns mathml string" do
        expect(formula).to eql("\\tilde{\\sum_{&}^{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("<i>tilde</i><i>n</i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("<i>tilde</i><i>70</i>")
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
      it "returns mathml string" do
        expect(formula).to eql("<i>tilde</i><i><i>&sum;</i><sub>&</sub><sup>so</sup></i>")
      end
    end
  end
end
