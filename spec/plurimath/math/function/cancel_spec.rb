require "spec_helper"

RSpec.describe Plurimath::Math::Function::Cancel do
  describe ".initialize" do
    it "returns instance of Cancel" do
      cancel = described_class.new("70")
      expect(cancel).to be_a(described_class)
    end

    it "initializes Cancel object" do
      cancel = described_class.new("70")
      expect(cancel.parameter_one).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns asciimath string" do
        expect(formula).to eq("cancel(n)")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns asciimath string" do
        expect(formula).to eq("cancel(70)")
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

      it "returns asciimath string" do
        expect(formula).to eq("cancel(sum_(&)^(\"so\"))")
      end
    end
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <menclose notation="updiagonalstrike">
            <mi>n</mi>
          </menclose>
        MATHML
        expect(formula).to be_xml_equivalent_to(expected_value)
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expected_value = <<~MATHML
          <menclose notation="updiagonalstrike">
            <mn>70</mn>
          </menclose>
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

      it "returns mathml string" do
        expected_value = <<~MATHML
          <menclose notation="updiagonalstrike">
            <mrow>
              <munderover>
                <mo>&#x2211;</mo>
                <mo>&</mo>
                <mtext>so</mtext>
              </munderover>
            </mrow>
          </menclose>
        MATHML
        expect(formula).to be_xml_equivalent_to(expected_value)
      end
    end
  end

  describe ".to_omml_without_math_tag" do
    let(:namespace) do
      { "m" => "http://schemas.openxmlformats.org/officeDocument/2006/math" }
    end
    let(:cancel) { described_class.new(first_value) }
    let(:document) do
      nodes = cancel.to_omml_without_math_tag(true, options: {})
      Oga.parse_xml("<root xmlns:m='#{namespace['m']}'>#{dump_ox_nodes(nodes)}</root>")
    end

    shared_examples "a diagonal cancellation" do
      it "encloses the original content with only an upward diagonal strike" do
        box = document.at_xpath("/root/m:borderBox", namespaces: namespace)
        expect(box).not_to be_nil
        expect(document.at_xpath("/root").xpath("*").length).to eq(1)
        expect(box.xpath("*").map(&:name)).to eq(%w[borderBoxPr e])
        properties = box.at_xpath("m:borderBoxPr", namespaces: namespace).xpath("*")
        expect(properties.map(&:name)).to eq(%w[hideTop hideBot hideLeft hideRight strikeBLTR])
        expect(properties.map { |property| property.xpath("@m:val", namespaces: namespace).first.value })
          .to eq(%w[on on on on on])
        expect(box.xpath("m:e//m:t", namespaces: namespace).map(&:text)).to eq(expected_text)
        expect(cancel.parameter_one).to equal(first_value)
      end
    end

    context "with a symbol" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:expected_text) { ["n"] }

      it_behaves_like "a diagonal cancellation"
    end

    context "with a number" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:expected_text) { ["70"] }

      it_behaves_like "a diagonal cancellation"
    end

    context "with a formula" do
      let(:first_value) { Plurimath::Math::Formula.new([Plurimath::Math::Number.new("70")]) }
      let(:expected_text) { ["70"] }

      it_behaves_like "a diagonal cancellation"
    end

    context "with an array containing an empty entry" do
      let(:first_value) do
        [Plurimath::Math::Symbols::Symbol.new("n"), nil, Plurimath::Math::Number.new("70")]
      end
      let(:expected_text) { ["n", "70"] }

      it_behaves_like "a diagonal cancellation"
    end

    context "with no argument" do
      let(:first_value) { nil }

      it "preserves an empty result" do
        expect(cancel.to_omml_without_math_tag(true, options: {})).to eq([])
      end
    end

    context "with an empty array" do
      let(:first_value) { [] }

      it "preserves an empty result" do
        expect(cancel.to_omml_without_math_tag(true, options: {})).to eq([])
      end
    end

    context "with another cancellation" do
      let(:first_value) { described_class.new(Plurimath::Math::Symbols::Symbol.new("n")) }
      let(:expected_text) { ["n"] }

      it_behaves_like "a diagonal cancellation"

      it "keeps both cancellation structures" do
        expect(document.xpath("/root/m:borderBox/m:e/m:borderBox", namespaces: namespace).length).to eq(1)
        expect(document.xpath("//m:strikeBLTR", namespaces: namespace).length).to eq(2)
      end
    end

    context "with an empty formula" do
      let(:first_value) { Plurimath::Math::Formula.new([]) }

      it "preserves an empty result" do
        expect(cancel.to_omml_without_math_tag(true, options: {})).to eq([])
      end
    end

    context "with an array containing an empty formula" do
      let(:first_value) { [Plurimath::Math::Formula.new([])] }

      it "preserves an empty result" do
        expect(cancel.to_omml_without_math_tag(true, options: {})).to eq([])
      end
    end

    context "with an empty nested cancellation" do
      let(:first_value) { described_class.new }

      it "preserves an empty result" do
        expect(cancel.to_omml_without_math_tag(true, options: {})).to eq([])
      end
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns mathml string" do
        expect(formula).to eql("\\cancel{n}")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns mathml string" do
        expect(formula).to eql("\\cancel{70}")
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

      it "returns mathml string" do
        expect(formula).to eql("\\cancel{\\sum_{\\&}^{\\text{so}}}")
      end
    end
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    context "contains Symbol as value" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }

      it "returns html string" do
        expect(formula).to eql("<i>cancel</i><i>n</i>")
      end
    end

    context "contains Number as value" do
      let(:first_value) { Plurimath::Math::Number.new("70") }

      it "returns html string" do
        expect(formula).to eql("<i>cancel</i><i>70</i>")
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

      it "returns html string" do
        expect(formula).to eql("<i>cancel</i><i><i>&sum;</i><sub>&</sub><sup>so</sup></i>")
      end
    end
  end
end
