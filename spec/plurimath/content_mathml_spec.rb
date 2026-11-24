# frozen_string_literal: true

require "spec_helper"

# The :content_mathml input type (plurimath#35): strict Content MathML read
# through the OpenMath model into a Formula.
RSpec.describe Plurimath::ContentMathml do
  def content(body)
    %(<math xmlns="http://www.w3.org/1998/Math/MathML">#{body}</math>)
  end

  def sym(name, dict: "arith1")
    %(<csymbol cd="#{dict}" name="#{name}"/>)
  end

  def apply(*parts)
    "<apply>#{parts.join}</apply>"
  end

  def parse(body)
    Plurimath::Math.parse(content(body), :content_mathml)
  end

  it "is a valid, input-only type" do
    expect(Plurimath::Math::VALID_TYPES).to include(content_mathml: described_class)
    expect(Plurimath::Math::INPUT_ONLY_TYPES).to include(:content_mathml)
  end

  it "routes apply/csymbol/ci/cn into the Formula model" do
    formula = parse(apply(sym("plus"), "<ci>x</ci>", "<cn>1</cn>"))

    expect(formula.value).to eq(
      [
        Plurimath::Math::Symbols::Symbol.new("x"),
        Plurimath::Math::Symbols::Plus.new,
        Plurimath::Math::Number.new("1"),
      ],
    )
  end

  it "writes Presentation MathML and the other formats" do
    formula = parse(apply(sym("times"), apply(sym("plus"), "<ci>a</ci>", "<cn>1</cn>"), "<ci>c</ci>"))

    expect(formula.to_asciimath).to eq("(a + 1) * c")
    expect(formula.to_mathml).to include("<mo>(</mo>", "<mi>a</mi>", "<mn>1</mn>", "<mi>c</mi>")
  end

  it "keeps operand grouping for minus, divide and power" do
    expect(parse(apply(sym("minus"), "<ci>x</ci>", apply(sym("minus"), "<ci>y</ci>", "<cn>2</cn>")))
      .to_asciimath).to eq("x - (y - 2)")
    expect(parse(apply(sym("divide"), "<ci>x</ci>", apply(sym("power"), "<ci>y</ci>", "<cn>2</cn>")))
      .to_mathml).to include("<mfrac>", "<msup>")
  end

  it "refuses a symbol with no Plurimath form" do
    expect { parse(apply(sym("sin", dict: "transc1"), "<ci>x</ci>")) }
      .to raise_error(Plurimath::Math::ParseError)
    expect { described_class.new(content(apply(sym("sin", dict: "transc1"), "<ci>x</ci>"))).to_formula }
      .to raise_error(described_class::UnsupportedError, /transc1\/sin/)
  end

  it "refuses Presentation MathML and wrong arity" do
    expect { parse("<mi>x</mi>") }.to raise_error(Plurimath::Math::ParseError)
    expect { parse(apply(sym("divide"), "<ci>x</ci>")) }.to raise_error(Plurimath::Math::ParseError)
  end
end
