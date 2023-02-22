require_relative '../../../../spec/spec_helper'

RSpec.describe Plurimath::Math::Function::Power do

  describe ".initialize" do
    it 'returns instance of Power' do
      power = Plurimath::Math::Function::Power.new("sum", "theta")
      expect(power).to be_a(Plurimath::Math::Function::Power)
    end

    it 'initializes Power object' do
      power = Plurimath::Math::Function::Power.new("sum", "theta")
      expect(power.parameter_one).to eql("sum")
      expect(power.parameter_two).to eql("theta")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value, second_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("n^(prod_(&)^(\"so\"))")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbol.new("n") }

      it "returns asciimath string" do
        expect(formula).to eq("70^(n)")
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
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("sum_(&)^(\"so\")^(prod_(&)^(\"so\"))")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Ox.dump(
        described_class.new(first_value, second_value).
          to_mathml_without_math_tag,
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <msup>
            <mi>n</mi>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&#x26;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </msup>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <msup>
            <mn>70</mn>
            <mi>n</mi>
          </msup>
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
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <msup>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&#x26;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&#x26;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </msup>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value, second_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("n^{\\prod_{&}^{\\text{so}}}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("70^{n}")
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
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\sum_{&}^{\\text{so}}^{\\prod_{&}^{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value, second_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("<i>n</i><sup><i>&prod;</i><sub>&</sub><sup>so</sup></sup>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("<i>70</i><sup>n</sup>")
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
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("<i><i>&sum;</i><sub>&</sub><sup>so</sup></i><sup><i>&prod;</i><sub>&</sub><sup>so</sup></sup>")
      end
    end
  end
end
