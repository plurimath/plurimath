require "spec_helper"

RSpec.describe Plurimath::Math::Function::Tr do

  describe ".initialize" do
    subject(:tr) { described_class.new([first]) }

    context "initialize Tr object" do
      let(:first) { "70" }

      it 'returns instance of Tr' do
        expect(tr).to be_a(Plurimath::Math::Function::Tr)
      end

      it 'initialize Tr object' do
        expect(tr.parameter_one).to eql(['70'])
      end
    end
  end

  describe ".to_asciimath" do
    subject(:tr) { described_class.new([first]).to_asciimath }

    context "returns instance of Tr" do
      let(:first) { Plurimath::Math::Symbol.new("theta") }

      it 'matches epxected value of Tr' do
        expect(tr).to eq("[theta]")
      end

      it "doesn't match epxected value of Tr" do
        expect(tr).not_to eq("[Theta]")
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new([first_value]).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns asciimath string" do
        expect(formula).to eq("[n]")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("[70]")
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
        expect(formula).to eq("[sum_(&)^(\"so\")]")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new([first_value]).
          to_mathml_without_math_tag,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) do
        Plurimath::Math::Function::Td.new([
          Plurimath::Math::Symbol.new("n")
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mtr>
            <mtd>
              <mi>n</mi>
            </mtd>
          </mtr>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) do
        Plurimath::Math::Function::Td.new([
          Plurimath::Math::Number.new("70")
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mtr>
            <mtd>
              <mn>70</mn>
            </mtd>
          </mtr>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Function::Td.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sum.new(
              Plurimath::Math::Symbol.new("&"),
              Plurimath::Math::Function::Text.new("so"),
            )
          ])
        ])
      end
      it "returns mathml string" do
        expected_value = <<~MATHML
          <mtr>
            <mtd>
              <mrow>
                <munderover>
                  <mo>&#x2211;</mo>
                  <mo>&#x26;</mo>
                  <mtext>so</mtext>
                </munderover>
              </mrow>
            </mtd>
          </mtr>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new([first_value]).to_latex }

    context "contains Symbol as value" do
      let(:first_value) do
        Plurimath::Math::Function::Td.new([
          Plurimath::Math::Symbol.new("n"),
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("n")
      end
    end

    context "contains Number as value" do
      let(:first_value) do
        Plurimath::Math::Function::Td.new([
          Plurimath::Math::Number.new("70"),
          Plurimath::Math::Symbol.new("n"),
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("70 n")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Function::Td.new([
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sum.new(
              Plurimath::Math::Symbol.new("&"),
              Plurimath::Math::Function::Text.new("so"),
            )
          ])
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\sum_{&}^{\\text{so}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new([first_value]).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("<tr>n</tr>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("<tr>70</tr>")
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
        expect(formula).to eql("<tr><i>&sum;</i><sub>&</sub><sup>so</sup></tr>")
      end
    end
  end
end
