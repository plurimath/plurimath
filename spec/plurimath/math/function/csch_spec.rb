require_relative '../../../../spec/spec_helper'

RSpec.describe Plurimath::Math::Function::Csch do

  describe ".initialize" do
    it 'returns instance of Csch' do
      csch = Plurimath::Math::Function::Csch.new('70')
      expect(csch).to be_a(Plurimath::Math::Function::Csch)
    end

    it 'initializes Csch object' do
      csch = Plurimath::Math::Function::Csch.new('70')
      expect(csch.parameter_one).to eql('70')
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) do
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Symbol.new("n")
          ],
          Plurimath::Math::Symbol.new(")")
        )
      end

      it "returns asciimath string" do
        expect(formula).to eq("csch(n)")
      end
    end

    context "contains Number as value" do
      let(:first_value) do
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Number.new("70"),
          ],
          Plurimath::Math::Symbol.new(")")
        )
      end

      it "returns asciimath string" do
        expect(formula).to eq("csch(70)")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Symbol.new("&"),
                Plurimath::Math::Function::Text.new("so"),
              )
            ])
          ],
          Plurimath::Math::Symbol.new(")")
        )
      end
      it "returns asciimath string" do
        expect(formula).to eq("csch(sum_(&)^(\"so\"))")
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

          <mrow>
            <mi>csch</mi>
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
            <mi>csch</mi>
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
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns mathml string" do
        expected_value = <<~MATHML
          <mrow>
            <mi>csch</mi>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&#x26;</mo>
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
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("\\csch{n}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("\\csch{70}")
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
        expect(formula).to eql("\\csch{\\sum_{&}^{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("<i>csch</i><i>n</i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("<i>csch</i><i>70</i>")
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
        expect(formula).to eql("<i>csch</i><i><i>&sum;</i><sub>&</sub><sup>so</sup></i>")
      end
    end
  end
end
