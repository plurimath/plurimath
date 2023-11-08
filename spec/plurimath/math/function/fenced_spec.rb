require "spec_helper"

RSpec.describe Plurimath::Math::Function::Fenced do

  describe ".initialize" do
    subject(:fenced) { Plurimath::Math::Function::Fenced.new(first, second, third) }

    context "initialize fenced object" do
      let(:first) { "sum" }
      let(:second) { "theta" }
      let(:third) { "square" }

      it 'returns instance of Fenced object' do
        expect(fenced).to be_a(Plurimath::Math::Function::Fenced)
      end

      it 'initialized Fenced object values' do
        expect(fenced.parameter_one).to eql("sum")
        expect(fenced.parameter_two).to eql("theta")
        expect(fenced.parameter_three).to eql("square")
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value, second_value, third_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("(") }
      let(:second_value) { [Plurimath::Math::Symbol.new("n")] }
      let(:third_value) { Plurimath::Math::Symbol.new(")") }

      it "returns asciimath string" do
        expect(formula).to eq("(n)")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("{") }
      let(:second_value) { [Plurimath::Math::Number.new("70")] }
      let(:third_value) { Plurimath::Math::Number.new("}") }

      it "returns asciimath string" do
        expect(formula).to eq("{70}")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("[") }
      let(:second_value) do
          [
            Plurimath::Math::Formula.new([
              Plurimath::Math::Function::Sum.new(
                Plurimath::Math::Symbol.new("&"),
                Plurimath::Math::Function::Text.new("so"),
              )
            ])
          ]
      end
      let(:third_value) { Plurimath::Math::Symbol.new("]") }
      it "returns asciimath string" do
        expect(formula).to eq("[sum_(&)^(\"so\")]")
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
      let(:first_value) { Plurimath::Math::Symbol.new("(") }
      let(:second_value) { [Plurimath::Math::Symbol.new("n")] }
      let(:third_value) { Plurimath::Math::Symbol.new(")") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mrow>
            <mo>(</mo>
            <mi>n</mi>
            <mo>)</mo>
          </mrow>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("(") }
      let(:second_value) { [Plurimath::Math::Number.new("70")] }
      let(:third_value) { Plurimath::Math::Symbol.new(")") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mrow>
            <mo>(</mo>
            <mn>70</mn>
            <mo>)</mo>
          </mrow>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Formula as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("(") }
      let(:second_value) do
        [
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sum.new(
              Plurimath::Math::Symbol.new("&"),
              Plurimath::Math::Function::Text.new("so"),
            )
          ])
        ]
      end
      let(:third_value) { Plurimath::Math::Symbol.new(")") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mrow>
            <mo>(</mo>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&#x26;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mo>)</mo>
          </mrow>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value, second_value, third_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("(") }
      let(:second_value) { [Plurimath::Math::Symbol.new("n")] }
      let(:third_value) { Plurimath::Math::Symbol.new(")") }

      it "returns mathml string" do
        expect(formula).to eql("( n )")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("{") }
      let(:second_value) { [Plurimath::Math::Number.new("70")] }
      let(:third_value) { Plurimath::Math::Symbol.new("}") }

      it "returns mathml string" do
        expect(formula).to eql("\\{ 70 \\}")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("[") }
      let(:second_value) do
        [
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sum.new(
              Plurimath::Math::Symbol.new("&"),
              Plurimath::Math::Function::Text.new("so"),
            )
          ])
        ]
      end
      let(:third_value) { Plurimath::Math::Symbol.new("]") }

      it "returns mathml string" do
        expect(formula).to eql("[ \\sum_{&}^{\\text{so}} ]")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value, second_value, third_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("(") }
      let(:second_value) { [Plurimath::Math::Symbol.new("n")] }
      let(:third_value) { Plurimath::Math::Symbol.new(")") }

      it "returns mathml string" do
        expect(formula).to eql("<i>(</i>n<i>)</i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("[") }
      let(:second_value) { [Plurimath::Math::Number.new("70")] }
      let(:third_value) { Plurimath::Math::Symbol.new("]") }

      it "returns mathml string" do
        expect(formula).to eql("<i>[</i>70<i>]</i>")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("{") }
      let(:second_value) do
        [
          Plurimath::Math::Formula.new([
            Plurimath::Math::Function::Sum.new(
              Plurimath::Math::Symbol.new("&"),
              Plurimath::Math::Function::Text.new("so"),
            )
          ])
        ]
      end
      let(:third_value) { Plurimath::Math::Symbol.new("}") }

      it "returns mathml string" do
        expect(formula).to eql("<i>{</i><i>&sum;</i><sub>&</sub><sup>so</sup><i>}</i>")
      end
    end
  end

  describe ".==" do
    subject(:fenced) { Plurimath::Math::Function::Fenced.new(first, second, third) }

    context "contains fenced object with default braces" do
      let(:first) { Plurimath::Math::Symbol.new("(") }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { Plurimath::Math::Symbol.new(")") }
      it "returns true" do
        expected_value = Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          [Plurimath::Math::Function::Sum.new],
          Plurimath::Math::Symbol.new(")"),
        )
        expect(fenced).to eq(expected_value)
      end
    end

    context "contains fenced object with curly braces" do
      let(:first) { Plurimath::Math::Symbol.new("{") }
      let(:second) { [Plurimath::Math::Function::Sum.new] }
      let(:third) { Plurimath::Math::Symbol.new("}") }
      it "returns false" do
        expected_value = Plurimath::Math::Function::Fenced.new(
          Plurimath::Math::Symbol.new("("),
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbol.new(")"),
        )
        expect(fenced).not_to eq(expected_value)
      end
    end
  end
end
