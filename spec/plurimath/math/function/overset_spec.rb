require "spec_helper"

RSpec.describe Plurimath::Math::Function::Overset do
  describe "OMML operand order" do
    let(:script) { Plurimath::Math::Function::Text.new("x", lang: :omml) }
    let(:base) { Plurimath::Math::Function::Text.new("y", lang: :omml) }
    let(:formula) { Plurimath::Math::Formula.new([described_class.new(script, base)]) }

    [true, false].each do |display_style|
      context "with display_style #{display_style}" do
        it "exports the base and script in their OMML fields" do
          document = Nokogiri::XML(formula.to_omml(display_style: display_style))
          namespace = { "m" => "http://schemas.openxmlformats.org/officeDocument/2006/math" }
          object_tag = display_style ? "limUpp" : "sSup"
          script_tag = display_style ? "lim" : "sup"
          object = document.at_xpath("//m:#{object_tag}", namespace)

          expect(object.at_xpath("m:e", namespace).text.strip).to eq("y")
          expect(object.at_xpath("m:#{script_tag}", namespace).text.strip).to eq("x")
        end
      end
    end

    it "preserves the model through display OMML export and import" do
      expect(Plurimath::Omml.new(formula.to_omml).to_formula).to eq(formula)
    end
  end

  describe ".initialize" do
    it "returns instance of Overset" do
      overset = described_class.new("70", "=")
      expect(overset).to be_a(described_class)
    end

    it "initializes Overset object" do
      overset = described_class.new("70", "=")
      expect(overset.parameter_one).to eql("70")
      expect(overset.parameter_two).to eql("=")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("overset(n)(prod_(&)^(\"so\"))")
      end
    end

    context "contains Number as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("overset(prod_(&)^(\"so\"))(70)")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Sum.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end
      let(:second_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end

      it "returns asciimath string" do
        expect(formula).to eq("overset(sum_(&)^(\"so\"))(prod_(&)^(\"so\"))")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
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
                                       ),
                                     ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML

          <mover>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mi>n</mi>
          </mover>
        MATHML
        expect(formula).to be_xml_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end
      let(:second_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mover>
            <mn>70</mn>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </mover>
        MATHML
        expect(formula).to be_xml_equivalent_to(expected_value)
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Sum.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end
      let(:second_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end

      it "returns mathml string" do
        expected_value = <<~MATHML
          <mover>
            <mrow>
              <munderover>
                <mo>&#x220f;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </mover>
        MATHML
        expect(formula).to be_xml_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\overset{n}{ \\left ( \\prod_{\\&}^{\\text{so}} \\right ) }")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\overset{70}{ \\left ( \\prod_{\\&}^{\\text{so}} \\right ) }")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Sum.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end
      let(:second_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end

      it "returns mathml string" do
        expect(formula).to eql("\\overset{ \\left ( \\sum_{\\&}^{\\text{so}} \\right ) }{ \\left ( \\prod_{\\&}^{\\text{so}} \\right ) }")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:second_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end

      it "returns html string" do
        expect(formula).to eql("<i>n</i><i><i>&prod;</i><sub>&</sub><sup>so</sup></i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns html string" do
        expect(formula).to eql("<i>70</i><i>n</i>")
      end
    end

    context "contains Formula as value" do
      let(:first_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Sum.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end
      let(:second_value) do
        Plurimath::Math::Formula.new([
                                       Plurimath::Math::Function::Prod.new(
                                         Plurimath::Math::Symbols::Ampersand.new,
                                         Plurimath::Math::Function::Text.new("so"),
                                       ),
                                     ])
      end

      it "returns html string" do
        expect(formula).to eql("<i><i>&sum;</i><sub>&</sub><sup>so</sup></i><i><i>&prod;</i><sub>&</sub><sup>so</sup></i>")
      end
    end
  end
end
