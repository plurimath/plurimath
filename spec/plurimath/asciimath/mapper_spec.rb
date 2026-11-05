# frozen_string_literal: true

require "spec_helper"

# AsciiMath parsing reads amath's typed model; the raw tree stays a separate,
# tree-level entry point (Asciimath::Parse) that parsing does not use.
RSpec.describe Plurimath::Asciimath::Mapper do
  inputs = [
    "x",
    "sum_(i=1)^n i^2",
    "(a",
    "((a,b),(c,d))",
    "sqrt(1.5) + frac{1}{2}",
    "\"text\" bb(X) color(red)(y)",
  ].freeze

  def raw_formula(input)
    text = Plurimath::Asciimath::Parser.new(input).text
    tree = Plurimath::Asciimath::Parse.new.parse(text)
    value = described_class::Rules.new.apply(tree)
    value.is_a?(Plurimath::Math::Formula) ? value : Plurimath::Math::Formula.new(value)
  end

  it "parses through Amath.parse with dialect L on the Ruby engine" do
    allow(Amath).to receive(:parse).and_call_original
    allow(Amath::Parser).to receive(:raw).and_call_original

    Plurimath::Math.parse("a+b", :asciimath)

    expect(Amath).to have_received(:parse)
      .with("a+b", dialect: :legacy, engine: :ruby, decimal: ".").once
    expect(Amath::Parser).not_to have_received(:raw)
  end

  inputs.each do |input|
    it "builds the same Formula as the raw tree for #{input}" do
      expect(Plurimath::Math.parse(input, :asciimath)).to eq(raw_formula(input))
    end
  end

  it "builds an empty Formula for empty input" do
    expect(Plurimath::Math.parse("", :asciimath)).to eq(raw_formula(""))
  end

  it "raises Parslet::ParseFailed for a refusal, as the raw tree does" do
    expect { Plurimath::Asciimath::Parser.new("a/").parse }
      .to raise_error(Parslet::ParseFailed)
  end
end
