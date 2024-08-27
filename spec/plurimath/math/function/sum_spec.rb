require "spec_helper"

RSpec.describe Plurimath::Math::Function::Sum do

  describe ".initialize" do
    it 'returns instance of Sum' do
      sum = Plurimath::Math::Function::Sum.new('70', '20')
      expect(sum).to be_a(Plurimath::Math::Function::Sum)
    end

    it 'initializes Sum object' do
      sum = Plurimath::Math::Function::Sum.new('70', '20')
      expect(sum.parameter_one).to eql('70')
      expect(sum.parameter_two).to eql('20')
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value, second_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("sum_(n)^(70)")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("sum_(70)^(sum_(&)^(\"so\"))")
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
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("sum_(sum_(&)^(\"so\"))^(prod_(&)^(\"so\"))")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value).
          to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <munderover>
            <mo>&#x2211;</mo>
            <mi>n</mi>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </munderover>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <munderover>
            <mo>&#x2211;</mo>
            <mn>70</mn>
            <mi>n</mi>
          </munderover>
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
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <munderover>
            <mo>&#x2211;</mo>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </munderover>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value, second_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\sum_{n}^{\\prod_{\\&}^{\\text{so}}}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("\\sum_{70}^{n}")
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
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\sum_{\\sum_{\\&}^{\\text{so}}}^{\\prod_{\\&}^{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value, second_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("<i>&sum;</i><sub>n</sub><sup><i>&prod;</i><sub>&</sub><sup>so</sup></sup>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("<i>&sum;</i><sub>70</sub><sup>n</sup>")
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
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("<i>&sum;</i><sub><i>&sum;</i><sub>&</sub><sup>so</sup></sub><sup><i>&prod;</i><sub>&</sub><sup>so</sup></sup>")
      end
    end
  end
end
