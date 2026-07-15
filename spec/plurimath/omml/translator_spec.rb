# frozen_string_literal: true

require "spec_helper"
require "plurimath/fixtures/formula_modules/expected_values"

RSpec.describe Plurimath::Omml::Translator do
  describe "#omml_to_plurimath" do
    it "raises for unsupported typed nodes" do
      expect { described_class.new.omml_to_plurimath(Object.new) }
        .to raise_error(
          Plurimath::Omml::UnsupportedNodeError,
          /Unsupported OMML typed node/,
        )
    end

    it "returns nil for non-semantic typed OMML nodes" do
      require "omml"

      Omml::Configuration.populate_context!
      ignored_types = %w[
        CTEmpty
        CTFPr
        CTOMathArgPr
        CTOMathParaPr
        CTCtrlPr
        CTBoxPr
      ]

      ignored_types.each do |type_name|
        node = Omml::Models.const_get(type_name)
          .new(lutaml_register: Omml::Configuration.context_id)

        expect(described_class.new.omml_to_plurimath(node)).to be_nil
      end
    end
  end

  describe "Plurimath::Omml#to_formula" do
    {
      "001" => ExpectedValues::EX_001,
      "057" => ExpectedValues::EX_057,
      "121" => ExpectedValues::EX_121,
      "187" => ExpectedValues::EX_187,
    }.each do |fixture_id, expected_formula|
      context "with ##{fixture_id}.omml" do
        let(:file_name) { "spec/plurimath/fixtures/omml/#{fixture_id}.omml" }

        it "parses through the omml repo typed models" do
          expect(Plurimath::Omml.new(File.read(file_name)).to_formula)
            .to eq(expected_formula)
        end
      end
    end

    context "when the omml context has not been populated yet" do
      let(:file_name) { "spec/plurimath/fixtures/omml/001.omml" }

      it "populates the omml context before parsing" do
        require "omml"

        Omml::Configuration.reset_context!

        expect(Plurimath::Omml.new(File.read(file_name)).to_formula)
          .to eq(ExpectedValues::EX_001)
      end
    end

    it "unwraps box elements as transparent containers" do
      omml = <<~OMML
        <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math">
          <m:oMath>
            <m:box>
              <m:e>
                <m:r><m:t>x</m:t></m:r>
              </m:e>
            </m:box>
          </m:oMath>
        </m:oMathPara>
      OMML

      expect(Plurimath::Omml.new(omml).to_formula.to_asciimath).to eq('"x"')
    end

    it "ignores non-semantic typed property and empty node tags" do
      omml = <<~OMML
        <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math">
          <m:oMathParaPr/>
          <m:oMath>
            <m:f>
              <m:fPr/>
              <m:num>
                <m:argPr/>
                <m:r><m:lastRenderedPageBreak/><m:t>x</m:t></m:r>
                <m:ctrlPr/>
              </m:num>
              <m:den>
                <m:r><m:t>y</m:t></m:r>
              </m:den>
            </m:f>
            <m:box>
              <m:boxPr/>
              <m:e>
                <m:r><m:t>2</m:t></m:r>
              </m:e>
            </m:box>
          </m:oMath>
        </m:oMathPara>
      OMML

      expect(Plurimath::Omml.new(omml).to_formula.to_asciimath)
        .to eq('frac("x")("y") 2')
    end

    context "when an m:r carries both m:rPr and w:rPr styling" do
      let(:omml) do
        <<~OMML
          <m:oMath xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                   xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
            <m:r>
              <m:rPr><m:sty m:val="p"/></m:rPr>
              <w:rPr><w:i/></w:rPr>
              <m:t>x</m:t>
            </m:r>
          </m:oMath>
        OMML
      end

      it "prefers the math-namespace style and renders without raising" do
        formula = Plurimath::Omml.new(omml).to_formula
        expect(formula.to_asciimath).to eq('rm("x")')
        expect(formula.to_latex).to eq("\\mathrm{\\text{x}}")
      end
    end

    context "when m:rPr/m:sty=b coexists with w:rPr/w:i" do
      let(:omml) do
        <<~OMML
          <m:oMath xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                   xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
            <m:r>
              <m:rPr><m:sty m:val="b"/></m:rPr>
              <w:rPr><w:i/></w:rPr>
              <m:t>x</m:t>
            </m:r>
          </m:oMath>
        OMML
      end

      it "prefers the math-namespace style (bold) over the Word-namespace italic" do
        expect(Plurimath::Omml.new(omml).to_formula.to_asciimath)
          .to eq('mathbf("x")')
      end
    end

    context "when an m:r carries WordprocessingML run inner content" do
      shared_examples "round-trips without raising" do
        it "parses and renders without raising UnsupportedNodeError" do
          formula = Plurimath::Omml.new(omml).to_formula
          expect { formula.to_asciimath }.not_to raise_error
          expect { formula.to_latex }.not_to raise_error
          expect { formula.to_mathml }.not_to raise_error
        end
      end

      context "with <w:br/> (line break)" do
        let(:omml) do
          <<~OMML
            <m:oMath xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                     xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
              <m:r><m:t>x</m:t><w:br/></m:r>
            </m:oMath>
          OMML
        end

        include_examples "round-trips without raising"

        it "emits a Linebreak node for the break" do
          formula = Plurimath::Omml.new(omml).to_formula
          expect(formula.to_asciimath).to include("\\")
        end
      end

      context "with text on both sides of <w:br/>" do
        let(:omml) do
          <<~OMML
            <m:oMath xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                     xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
              <m:r><m:t>x</m:t><w:br/><m:t>y</m:t></m:r>
            </m:oMath>
          OMML
        end

        it "preserves the text after the line break" do
          formula = Plurimath::Omml.new(omml).to_formula
          expect(formula.to_asciimath).to eq("\"x\" \\\n  \"y\"")
          expect(formula.to_latex).to eq("\\text{x} \\\\  \\text{y}")
        end
      end

      context "with <w:tab/>" do
        let(:omml) do
          <<~OMML
            <m:oMath xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                     xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
              <m:r><m:t>a</m:t><w:tab/><m:t>b</m:t></m:r>
            </m:oMath>
          OMML
        end

        include_examples "round-trips without raising"
      end

      context "with <w:cr/> (carriage return)" do
        let(:omml) do
          <<~OMML
            <m:oMath xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                     xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
              <m:r><m:t>a</m:t><w:cr/><m:t>b</m:t></m:r>
            </m:oMath>
          OMML
        end

        include_examples "round-trips without raising"
      end

      context "with <w:noBreakHyphen/>" do
        let(:omml) do
          <<~OMML
            <m:oMath xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                     xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
              <m:r><m:t>a</m:t><w:noBreakHyphen/><m:t>b</m:t></m:r>
            </m:oMath>
          OMML
        end

        include_examples "round-trips without raising"
      end
    end
  end
end
