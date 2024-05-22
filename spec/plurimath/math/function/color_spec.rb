require "spec_helper"

RSpec.describe Plurimath::Math::Function::Color do

  describe ".initialize" do
    it 'returns instance of Color' do
      color = Plurimath::Math::Function::Color.new('red', '70')
      expect(color).to be_a(Plurimath::Math::Function::Color)
    end

    it 'initializes Color object' do
      color = Plurimath::Math::Function::Color.new('red', '70')
      expect(color.parameter_one).to eql('red')
      expect(color.parameter_two).to eql('70')
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value, second_value).to_asciimath }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("red") }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns asciimath string" do
        expect(formula).to eq("color(red)(n)")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("blue") }
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("color(\"blue\")(70)")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("blac") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns asciimath string" do
        expect(formula).to eq("color(\"blac\")(sum_(&)^(\"so\"))")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value).
          to_mathml_without_math_tag(false),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("red") }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mstyle mathcolor="red">
            <mi>n</mi>
          </mstyle>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("red") }
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mstyle mathcolor="red">
            <mn>70</mn>
          </mstyle>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end

    context "contains Formula as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("blac") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns mathml string" do
        expected_value = <<~MATHML
          <mstyle mathcolor="blac">
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </mstyle>
        MATHML
        expect(formula).to be_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value, second_value).to_latex }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("nas") }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("{\\color{\"nas\"} n}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("pink") }
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("{\\color{pink} 70}")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("red") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns mathml string" do
        expect(formula).to eql("{\\color{red} \\sum_{\\&}^{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value, second_value).to_html }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("nas") }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("<i>nas</i><i>n</i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("rad") }
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("<i>rad</i><i>70</i>")
      end
    end

    context "contains Formula as value" do
      let(:first_value) { Plurimath::Math::Function::Text.new("red") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Sum.new(
            Plurimath::Math::Symbols::Ampersand.new,
            Plurimath::Math::Function::Text.new("so"),
          )
        ])
      end
      it "returns mathml string" do
        expect(formula).to eql("<i>red</i><i><i>&sum;</i><sub>&</sub><sup>so</sup></i>")
      end
    end
  end
end
