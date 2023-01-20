require_relative '../../../../spec/spec_helper'

RSpec.describe Plurimath::Math::Function::Base do

  it 'returns instance of Base' do
    base = Plurimath::Math::Function::Base.new("sum", "theta")
    expect(base).to be_a(Plurimath::Math::Function::Base)
  end

  it 'initializes Base object' do
    base = Plurimath::Math::Function::Base.new("sum", "theta")
    expect(base.parameter_one).to eql("sum")
    expect(base.parameter_two).to eql("theta")
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value, second_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbol.new("n") }

      it "returns asciimath string" do
        expect(formula).to eq("70_(n)")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("n_(70)")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("so") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("\"so\"_(sum_(&)^(\"so\"))")
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

          <msub>
            <mi>n</mi>
            <mn>70</mn>
          </msub>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <msub>
            <mi>n</mi>
            <mn>70</mn>
          </msub>
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
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <msub>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&#x26;</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mn>70</mn>
          </msub>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value, second_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("n_{70}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbol.new("&"),
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("70_{\\sum_{&}^{\\text{so}}}")
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
        expect(formula).to eql("{\\sum_{&}^{\\text{so}}}_{\\prod_{&}^{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value, second_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbol.new("n") }
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("<i>n</i><sub>70</sub>")
      end
    end

    context "contains Number as value" do
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
        expect(formula).to eql("<i>n</i><sub><i>&prod;</i><sub>&</sub><sup>so</sup></sub>")
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
        expect(formula).to eql("<i><i>&sum;</i><sub>&</sub><sup>so</sup></i><sub><i>&prod;</i><sub>&</sub><sup>so</sup></sub>")
      end
    end
  end
end
