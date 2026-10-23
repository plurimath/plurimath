# frozen_string_literal: true

require "spec_helper"

# OMML has no <mn>/<mi> split: a run whose whole text is a number must
# read as Math::Number, so MathML written from OMML input uses <mn>.
RSpec.describe Plurimath::Omml do
  ns = 'xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"'

  define_method(:omml) do |body|
    %(<m:oMathPara #{ns}><m:oMath>#{body}</m:oMath></m:oMathPara>)
  end

  def run(text)
    "<m:r><m:t>#{text}</m:t></m:r>"
  end

  def read(body)
    described_class.new(omml(body)).to_formula
  end

  def number(text)
    Plurimath::Math::Number.new(text)
  end

  def mathml_tokens(formula)
    formula.to_mathml.scan(%r{<(m[ino]|mtext)>([^<]*)</\1>})
  end

  describe "a run holding only a number" do
    {
      "integer" => "42",
      "decimal" => "1.23",
      "decimal below one" => "0.5",
    }.each do |label, text|
      it "reads a #{label} as Math::Number and writes <mn>" do
        formula = read(run(text))

        expect(formula.value).to eq([number(text)])
        expect(mathml_tokens(formula)).to eq([["mn", text]])
      end
    end
  end

  describe "runs that are not a number" do
    it "keeps a letter run as text" do
      expect(read(run("abc")).value)
        .to eq([Plurimath::Math::Function::Text.new("abc", lang: :omml)])
    end

    it "keeps a mixed run such as 2x as text" do
      expect(read(run("2x")).value)
        .to eq([Plurimath::Math::Function::Text.new("2x", lang: :omml)])
    end

    it "keeps operators and malformed numbers as symbols" do
      %w[- + 1.2.3 1. .5 1,5].each do |text|
        value = read(run(text)).value.first
        expect(value).not_to be_a(Plurimath::Math::Number), text
      end
    end
  end

  it "reads a negative number as a minus run then a number run" do
    formula = read(run("\u2212") + run("0.5"))

    expect(formula.value)
      .to eq([Plurimath::Math::Symbols::Minus.new, number("0.5")])
    expect(mathml_tokens(formula)).to eq([["mo", "&#x2212;"], ["mn", "0.5"]])
  end

  it "keeps a signed single run such as -1 as a symbol" do
    expect(read(run("-1")).value)
      .to eq([Plurimath::Math::Symbols::Symbol.new("-1")])
  end

  it "reads a number run next to a letter run" do
    formula = read(run("2.5") + run("x"))

    expect(formula.value.first).to eq(number("2.5"))
    expect(mathml_tokens(formula).first).to eq(["mn", "2.5"])
  end

  it "reads numbers in a subscript and a superscript" do
    body = "<m:sSubSup><m:e>#{run('x')}</m:e>" \
           "<m:sub>#{run('1.5')}</m:sub><m:sup>#{run('2')}</m:sup></m:sSubSup>"
    node = read(body).value.first

    expect(node.parameter_two).to eq(number("1.5"))
    expect(node.parameter_three).to eq(number("2"))
    expect(mathml_tokens(read(body))).to include(["mn", "1.5"], ["mn", "2"])
  end

  describe "round trip Formula -> OMML -> Formula" do
    [
      "1.23",
      "3 + 4.5",
      "0.25 * 7",
      "frac(1.5)(2)",
      "sqrt(2.25)",
      "-5",
      "-0.5",
      "10^(1.5)",
    ].each do |source|
      it "keeps #{source.inspect} equal" do
        formula = Plurimath::Math.parse(source, :asciimath)
        back = Plurimath::Math.parse(formula.to_omml, :omml)

        expect(back).to eq(formula)
      end
    end
  end
end
