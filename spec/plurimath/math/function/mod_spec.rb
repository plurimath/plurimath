require_relative '../../../../spec/spec_helper'

RSpec.describe Plurimath::Math::Function::Mod do

  describe ".initialize" do
    it 'returns instance of Mod' do
      mod = Plurimath::Math::Function::Mod.new(70, 3)
      expect(mod).to be_a(Plurimath::Math::Function::Mod)
    end

    it 'initializes Mod object' do
      mod = Plurimath::Math::Function::Mod.new(70, 3)
      expect(mod.parameter_one).to eql(70)
      expect(mod.parameter_two).to eql(3)
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
        expect(formula).to eq("n mod prod_(&)^(\"so\")")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbol.new("n") }

      it "returns asciimath string" do
        expect(formula).to eq("70 mod n")
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
        expect(formula).to eq("sum_(&)^(\"so\") mod prod_(&)^(\"so\")")
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
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mrow>
            <mi>n</mi>
            <mi>mod</mi>
            <mn>70</mn>
          </mrow>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
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
          <mrow>
            <mn>70</mn>
            <mi>mod</mi>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&amp;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
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
          <mrow>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&amp;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mi>mod</mi>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&amp;</mo>
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
        expect(formula).to eql("{n} \\mod {\\prod_{&}^{\\text{so}}}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("{70} \\mod {n}")
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
        expect(formula).to eql("{\\sum_{&}^{\\text{so}}} \\mod {\\prod_{&}^{\\text{so}}}")
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
        expect(formula).to eql("<i>n</i><i>mod</i><i><i>&prod;</i><sub>&</sub><sup>so</sup></i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("<i>70</i><i>mod</i><i>n</i>")
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
        expect(formula).to eql("<i><i>&sum;</i><sub>&</sub><sup>so</sup></i><i>mod</i><i><i>&prod;</i><sub>&</sub><sup>so</sup></i>")
      end
    end
  end
end
