# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::ContentMathml, engine_loop: :always do
  let(:namespace) { 'xmlns="http://www.w3.org/1998/Math/MathML"' }

  def parse_content(body, version: 2)
    Plurimath::Math.parse("<math #{namespace}>#{body}</math>",
                          :content_mathml, version: version)
  end

  it "registers a writable Content MathML notation" do
    expect(Plurimath::Math::VALID_TYPES[:content_mathml]).to eq(described_class)
    expect(Plurimath::Math::INPUT_ONLY_TYPES).not_to include(:content_mathml)
  end

  it "delegates csymbol and apply to the gem's shared content models" do
    xml = '<apply><csymbol cd="arith1" name="plus"/><cn type="integer">2</cn><cn type="integer">3</cn></apply>'
    allow(Openmath::ContentMathML).to receive(:parse).and_call_original
    formula = parse_content(xml)
    expect(Openmath::ContentMathML).to have_received(:parse).with(anything, version: 2)
    expect(formula.evaluate.value).to eq(5)
    expect(formula.to_openmath).to include('cd="arith1"', 'name="plus"')
    expect(Plurimath::Math.parse(formula.to_content_mathml, :content_mathml).evaluate.value).to eq(5)
  end

  it "accepts non-strict operators and writes the strict form" do
    formula = parse_content('<apply><times/><cn type="integer">2</cn><ci>x</ci></apply>')
    expect(formula.evaluate(x: 3).value).to eq(6)
    expect(formula.to_content_mathml).to include("csymbol", "arith1", "times")
  end

  it "selects either OpenMath model version" do
    [2, 3].each do |version|
      formula = parse_content('<cn type="integer">42</cn>', version: version)
      expect(formula.openmath_source.class.name).to eq("Openmath::V#{version}::Omobj")
      expect(formula.evaluate.value).to eq(42)
    end
    expect { parse_content("<ci>x</ci>", version: 4) }.to raise_error(Plurimath::Math::ParseError)
  end

  it "retains lambda and bvar as binding containers in both directions" do
    formula = parse_content("<lambda><bvar><ci>x</ci></bvar><ci>x</ci></lambda>")
    xml = formula.to_openmath
    expect(xml).to include("OMBIND", "OMBVAR", 'name="lambda"', 'name="x"')
    content = Plurimath::Math.parse(xml, :openmath).to_content_mathml
    expect(content).to include("lambda", "bvar")
    expect { formula.to_asciimath }.to raise_error(Plurimath::Openmath::UnsupportedError)
    expect { formula.evaluate }.to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError)
  end

  it "retains custom symbol identity and CD base" do
    formula = parse_content('<csymbol cd="custom" name="alpha" cdbase="https://example.org/cd"/>')
    expect(formula.to_openmath).to include('cd="custom"', 'cdbase="https://example.org/cd"')
    expect(formula.to_content_mathml).to include('cd="custom"', 'cdbase="https://example.org/cd"')
  end

  it "refuses content with no supported semantic mapping" do
    ["<mi>x</mi>", '<apply><csymbol cd="custom" name="f"/><cn>2</cn></apply>'].each do |body|
      expect { parse_content(body) }.to raise_error(Plurimath::Math::ParseError)
    end
  end

  it "writes ordinary Formula trees through the gem's content writer" do
    formula = Plurimath::Math.parse("1/4", :asciimath)
    allow(Openmath::ContentMathML).to receive(:generate).and_call_original
    expect(Plurimath::Math.parse(formula.to_content_mathml, :content_mathml).evaluate.value).to eq(Rational(1, 4))
    expect(Openmath::ContentMathML).to have_received(:generate)
  end

  it "accepts Content MathML in the registry-derived CLI" do
    require "plurimath/cli"
    expect do
      Plurimath::Cli.start(["convert", "--input", "2", "--output-format", "content_mathml"])
    end.to output(/<cn/).to_stdout
  end
end
