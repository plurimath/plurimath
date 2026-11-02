# frozen_string_literal: true

require "spec_helper"

# The intent string is metadata: OMML has nowhere to carry it, so Intent must
# write only its content. The inherited BinaryFunction rendering nested the
# content's runs inside an outer <m:r> (which the OMML reader parses to an
# empty formula) and printed the intent text as a visible run.
RSpec.describe Plurimath::Math::Function::Intent do
  def symbol(value)
    Plurimath::Math::Symbols::Symbol.new(value)
  end

  def bare_omml(formula)
    formula.to_omml.lines.reject { |line| line.include?("xmlns") }.join
  end

  let(:content) do
    Plurimath::Math::Formula.new([symbol("a"), Plurimath::Math::Symbols::Plus.new, symbol("b")])
  end
  let(:intent) do
    described_class.new(content, Plurimath::Math::Function::Text.new("bar-intent"))
  end
  let(:formula) { Plurimath::Math::Formula.new([intent]) }
  let(:plain) do
    Plurimath::Math::Formula.new([symbol("a"), Plurimath::Math::Symbols::Plus.new, symbol("b")])
  end

  it "writes the same OMML as its content alone" do
    expect(bare_omml(formula)).to eq(bare_omml(plain))
  end

  it "does not write the intent text or nest runs" do
    omml = formula.to_omml
    expect(omml).not_to include("bar-intent")
    expect(omml).not_to match(%r{<m:r>\s*<m:r>})
  end

  it "writes OMML the OMML reader parses back to the content" do
    parsed = Plurimath::Math.parse(formula.to_omml, :omml)
    expected = Plurimath::Math.parse(plain.to_omml, :omml)
    expect(parsed.value).not_to be_empty
    expect(parsed.to_asciimath).to eq(expected.to_asciimath)
  end

  it "writes no OMML when it has no content" do
    expect(described_class.new(nil, Plurimath::Math::Function::Text.new("x"))
      .to_omml_without_math_tag(true, options: {})).to eq([])
  end

  it "drops the intent text from MathML input converted to OMML" do
    mathml = <<~MATHML
      <math xmlns="http://www.w3.org/1998/Math/MathML">
        <mrow intent="foo($x)"><mi arg="x">x</mi><mo>+</mo><mn>1</mn></mrow>
      </math>
    MATHML
    plain_mathml = <<~MATHML
      <math xmlns="http://www.w3.org/1998/Math/MathML">
        <mrow><mi>x</mi><mo>+</mo><mn>1</mn></mrow>
      </math>
    MATHML
    parsed = Plurimath::Math.parse(mathml, :mathml)
    expect(parsed.value.first).to be_a(described_class)
    omml = parsed.to_omml
    expect(omml).not_to include("foo(")
    expect(bare_omml(parsed)).to eq(bare_omml(Plurimath::Math.parse(plain_mathml, :mathml)))
    expect(Plurimath::Math.parse(omml, :omml).value).not_to be_empty
  end

  it "does not write the intent text into HTML" do
    expect(formula.to_html).not_to include("bar-intent")
    expect(formula.to_html).to include("a")
  end
end
