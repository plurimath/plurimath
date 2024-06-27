require "spec_helper"

RSpec.describe Plurimath::Math::Function::PowerBase do
  describe ".initialize" do
    subject(:power_base) { Plurimath::Math::Function::PowerBase.new(first, second, third) }

    context "initialize PowerBase object" do
      let(:first) { Plurimath::Math::Function::Sum.new }
      let(:second) { Plurimath::Math::Symbols::Symbol.new("Theta") }
      let(:third) { Plurimath::Math::Symbols::Symbol.new("square") }

      it 'returns instance of PowerBase' do
        expect(power_base).to be_a(Plurimath::Math::Function::PowerBase)
      end

      it 'initializes PowerBase object' do
        expect(power_base.parameter_one).to eq(Plurimath::Math::Function::Sum.new)
        expect(power_base.parameter_two).to eq(Plurimath::Math::Symbols::Symbol.new("Theta"))
        expect(power_base.parameter_three).to eq(Plurimath::Math::Symbols::Symbol.new("square"))
      end
    end
  end

  describe ".==" do
    subject(:power_base) { Plurimath::Math::Function::PowerBase.new(first, second, third) }

    context "contains PowerBase object" do
      let(:first) { Plurimath::Math::Function::Sum.new }
      let(:second) { Plurimath::Math::Symbols::Symbol.new("Theta") }
      let(:third) { Plurimath::Math::Symbols::Symbol.new("square") }

      it 'matches epxected value' do
        expected_value = Plurimath::Math::Function::PowerBase.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbols::Symbol.new("Theta"),
          Plurimath::Math::Symbols::Symbol.new("square"),
        )
        expect(power_base).to eq(expected_value)
      end

      it 'matches epxected value' do
        expected_value = Plurimath::Math::Function::PowerBase.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbols::Symbol.new("theta"),
          Plurimath::Math::Symbols::Symbol.new("square"),
        )
        expect(power_base).not_to eq(expected_value)
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value, second_value, third_value).to_asciimath }

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
      let(:third_value) { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("n_(prod_(&)^(\"so\"))^(70)")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) { Plurimath::Math::Number.new("70") }
      let(:third_value) { Plurimath::Math::Symbols::Delta.new }

      it "returns asciimath string" do
        expect(formula).to eq("n_(70)^(delta)")
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
      let(:second_value) { Plurimath::Math::Function::Text.new("something") }
      let(:third_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("(sum_(&)^(\"so\"))_(\"something\")^(prod_(&)^(\"so\"))")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value, third_value).
          to_mathml_without_math_tag(false),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) { Plurimath::Math::Number.new("70") }
      let(:third_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <msubsup>
            <mi>n</mi>
            <mn>70</mn>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </msubsup>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      let(:third_value) { Plurimath::Math::Function::Text.new("s") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <msubsup>
            <mn>70</mn>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mtext>s</mtext>
          </msubsup>
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
      let(:second_value) { Plurimath::Math::Number.new("120") }
      let(:third_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <msubsup>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mn>120</mn>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </msubsup>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value, second_value, third_value).to_latex }

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
      let(:third_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("n_{\\prod_{\\&}^{\\text{so}}}^{\\prod_{\\&}^{\\text{so}}}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbols::Vdash.new }
      let(:third_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("70_{\\vdash}^{70}")
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
      let(:third_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Stackrel.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\sum_{\\&}^{\\text{so}}_{\\prod_{\\&}^{\\text{so}}}^{\\stackrel{\\&}{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value, second_value, third_value).to_html }

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
      let(:third_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expected_value = <<~HTML
          <i>n</i>
          <sub>
            <i>&prod;</i>
            <sub>&</sub>
            <sup>so</sup>
          </sub>
          <sup>
            <i>&sum;</i>
            <sub>&</sub>
            <sup>so</sup>
          </sup>
        HTML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("&#x2200;") }
      let(:third_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end

      it "returns mathml string" do
        expect(formula).to eql("<i>70</i><sub>&#x2200;</sub><sup><i>&sum;</i><sub>&</sub><sup>so</sup></sup>")
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
          Plurimath::Math::Function::Stackrel.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      let(:third_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Prod.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns mathml string" do
        expected_value = <<~HTML
          <i>
            <i>&sum;</i>
            <sub>&</sub>
            <sup>so</sup>
          </i>
          <sub>&so</sub>
          <sup>
            <i>&prod;</i>
            <sub>&</sub>
            <sup>so</sup>
          </sup>
        HTML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end
end
