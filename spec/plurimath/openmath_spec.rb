# frozen_string_literal: true

require "spec_helper"

# The :openmath notation (plurimath#585): OpenMath XML parses through the
# openmath gem into a Formula; the bound content-dictionary core renders in
# every target; symbols outside the converter's table refuse.
RSpec.describe Plurimath::Openmath, engine_loop: :always do
  let(:namespace) { "http://www.openmath.org/OpenMath" }
  let(:presentation_formats) { %i[to_asciimath to_latex to_mathml to_omml to_unicodemath to_html] }

  def parse(body)
    Plurimath::Math.parse(%(<OMOBJ xmlns="#{namespace}">#{body}</OMOBJ>), :openmath)
  end

  it "is a valid input type" do
    expect(Plurimath::Math::VALID_TYPES).to include(openmath: described_class)
  end

  it "parses an application into the infix Formula the other notations build" do
    formula = parse('<OMA><OMS cd="arith1" name="plus"/><OMI>1</OMI><OMI>1</OMI></OMA>')
    expect(formula.value.map(&:class)).to eq(
      [Plurimath::Math::Number, Plurimath::Math::Symbols::Plus, Plurimath::Math::Number],
    )
    expect(formula.to_asciimath).to eq("1 + 1")
  end

  it "converts divided_by to the exact fraction form" do
    expect(parse('<OMA><OMS cd="arith1" name="divided_by"/><OMI>1</OMI><OMI>4</OMI></OMA>').to_latex)
      .to eq("1 / 4")
  end

  it "converts power structurally" do
    formula = parse('<OMA><OMS cd="arith1" name="power"/><OMV name="x"/><OMI>2</OMI></OMA>')
    expect(formula.to_asciimath).to eq("x^(2)")
  end

  # The comparison examples use the same source on each engine. Keep independent
  # copies because the writer refusal example edits its Formula.
  before(:context) { @comparison_snapshots = {} }

  def comparison_formula(body, version:)
    key = [Plurimath.xml_engine, Mml::V4::Configuration.adapter, body, version]
    snapshot = @comparison_snapshots[key] ||= Marshal.dump(openmath(body, version: version))
    Marshal.load(snapshot)
  end

  [2, 3].each do |version|
    {
      "eq" => Plurimath::Math::Symbols::Equal,
      "neq" => Plurimath::Math::Symbols::Ne,
      "gt" => Plurimath::Math::Symbols::Greater,
      "lt" => Plurimath::Math::Symbols::Less,
      "geq" => Plurimath::Math::Symbols::Geq,
      "leq" => Plurimath::Math::Symbols::Leq,
    }.each do |name, symbol|
      context "with relation1/#{name} in OpenMath version #{version}" do
        it "parses, renders and replays its retained source" do
          formula = comparison_formula(%(<OMA><OMS cd="relation1" name="#{name}"/><OMI>2</OMI><OMI>3</OMI></OMA>), version: version)
          expect(formula.value.map(&:class)).to eq([Plurimath::Math::Number, symbol, Plurimath::Math::Number])
          replayed = Plurimath::Math.parse(formula.to_openmath(version: version), :openmath, version: version)
          expect(replayed.value).to eq(formula.value)
          presentation_formats.each do |format|
            expect(formula.public_send(format)).not_to be_empty
          end
        end

        it "refuses to write fresh or edited comparison nodes" do
          formula = comparison_formula(%(<OMA><OMS cd="relation1" name="#{name}"/><OMI>2</OMI><OMI>3</OMI></OMA>), version: version)
          fresh = Plurimath::Math::Formula.new(formula.value)
          expect { fresh.to_openmath(version: version) }.to raise_error(Plurimath::Openmath::UnsupportedError)
          formula.value.first.value = "4"
          expect { formula.to_openmath(version: version) }.to raise_error(Plurimath::Openmath::UnsupportedError)
        end

        it "refuses scalar evaluation with or without retained source in either mode" do
          formula = comparison_formula(%(<OMA><OMS cd="relation1" name="#{name}"/><OMI>2</OMI><OMI>3</OMI></OMA>), version: version)
          [formula, Plurimath::Math::Formula.new(formula.value)].each do |candidate|
            expect { candidate.evaluate }.to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError)
            expect { candidate.evaluate({}, mode: :strict) }
              .to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError)
          end
        end
      end
    end
  end

  it "renders openmath-parsed formulas in every target" do
    formula = parse('<OMA><OMS cd="arith1" name="times"/><OMI>2</OMI><OMI>3</OMI></OMA>')
    %i[to_asciimath to_latex to_mathml to_omml to_unicodemath to_html].each do |format|
      expect { formula.public_send(format) }.not_to raise_error
    end
  end

  it "refuses symbols outside the converter's table with a ParseError" do
    expect { parse('<OMA><OMS cd="mycd" name="f"/><OMI>1</OMI></OMA>') }
      .to raise_error(Plurimath::Math::ParseError)
  end

  it "round-trips through amath's shared corpus semantics" do
    formula = parse('<OMA><OMS cd="arith1" name="plus"/><OMI>1 000</OMI><OMI>1</OMI></OMA>')
    expect(formula.to_asciimath).to eq("1000 + 1")
  end

  def openmath(body, version: 2)
    Plurimath::Math.parse(%(<OMOBJ xmlns="http://www.openmath.org/OpenMath">#{body}</OMOBJ>),
                          :openmath, version: version)
  end

  it "selects either model version through the public parser" do
    [2, 3].each do |version|
      formula = openmath("<OMI>42</OMI>", version: version)
      expect(formula.openmath_source.class.name).to eq("Openmath::V#{version}::Omobj")
      expect(formula.evaluate.value).to eq(42)
      expect(formula.to_openmath(version: version)).to include(%(version="#{version}.0"))
    end
    expect { openmath("<OMI>1</OMI>", version: 4) }.to raise_error(Plurimath::Math::ParseError)
    expect { Plurimath::Math.parse("1", :asciimath, version: 2) }
      .to raise_error(Plurimath::Math::ParseOptionError)
  end

  it "uses the same accuracy boundaries and modes as the ordinary evaluator" do
    formula = openmath('<OMA><OMS cd="arith1" name="divided_by"/><OMV name="x"/><OMI>4</OMI></OMA>')
    result = formula.evaluate(x: 1)
    expect(result.value).to eq(Rational(1, 4))
    ordinary = Plurimath::Math.parse("x/4", :asciimath)
    expect(result).to eq(ordinary.evaluate(x: 1))
    expect(formula.evaluate({ x: 1 }, mode: :strict)).to eq(ordinary.evaluate({ x: 1 }, mode: :strict))
    expect(formula.evaluate({ x: 1 }, mode: :strict).boundaries)
      .to eq(ordinary.evaluate({ x: 1 }, mode: :strict).boundaries)
  end

  it "preserves an unknown CD symbol and its declared base" do
    formula = openmath('<OMS cd="custom" name="alpha" cdbase="https://example.org/cd"/>')
    %i[to_asciimath to_latex to_mathml to_omml to_unicodemath to_html].each do |writer|
      expect { formula.public_send(writer) }.to raise_error(Plurimath::Openmath::UnsupportedError)
    end
    expect(formula.to_openmath).to include('cd="custom"', 'name="alpha"', 'cdbase="https://example.org/cd"')
    expect { formula.evaluate }.to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError)
  end

  it "retains error objects for serialization and evaluation" do
    formula = openmath('<OME><OMS cd="error" name="unexpected"/><OMSTR>bad</OMSTR></OME>')
    expect(formula.to_openmath).to include("<OME>")
    expect { formula.to_asciimath }.to raise_error(Plurimath::Openmath::UnsupportedError)
    expect { formula.evaluate }.to raise_error(Plurimath::Errors::Evaluation::UnsupportedExpressionError)
  end

  it "does not use a stale source after the Formula is edited" do
    formula = openmath("<OMI>1</OMI>")
    formula.value.first.value = "2"
    expect(formula.to_openmath).to include(">2</OMI>")
    expect(formula.evaluate.value).to eq(2)
  end

  it "keeps nested operations grouped in presentation output" do
    formula = openmath('<OMA><OMS cd="arith1" name="times"/><OMA><OMS cd="arith1" name="plus"/><OMI>1</OMI><OMI>2</OMI></OMA><OMI>3</OMI></OMA>')
    expect(formula.to_asciimath).to include("(1 + 2)")
    expect(formula.evaluate.value).to eq(9)
    expect(openmath('<OMA><OMS cd="arith1" name="unary_minus"/><OMI>2</OMI></OMA>').to_asciimath).to eq("- 2")
  end

  it "maps rational constructors, extrema and rounding functions" do
    {
      '<OMA><OMS cd="nums1" name="rational"/><OMI>1</OMI><OMI>4</OMI></OMA>' => Rational(1, 4),
      '<OMA><OMS cd="arith1" name="max"/><OMI>1</OMI><OMI>4</OMI><OMI>2</OMI></OMA>' => 4,
      '<OMA><OMS cd="rounding1" name="floor"/><OMF dec="1.5"/></OMA>' => 1,
    }.each do |input, expected|
      formula = openmath(input)
      expect(formula.evaluate.value).to eq(expected)
      formula.openmath_source = nil
      expect(Plurimath::Math.parse(formula.to_openmath, :openmath).evaluate.value).to eq(expected)
    end
  end

  it "refuses malformed arities, multiple root objects and custom operations" do
    [
      '<OMA><OMS cd="arith1" name="power"/><OMI>1</OMI></OMA>',
      '<OMA><OMS cd="arith1" name="minus"/><OMI>1</OMI><OMI>2</OMI><OMI>3</OMI></OMA>',
      '<OMA><OMS cd="arith1" name="plus" cdbase="https://example.org/cd"/><OMI>1</OMI><OMI>2</OMI></OMA>',
      "<OMI>1</OMI><OMI>2</OMI>",
    ].each do |body|
      expect { openmath(body) }.to raise_error(Plurimath::Math::ParseError)
    end
  end

  it "writes mapped expressions from each presentation notation" do
    expression = openmath('<OMA><OMS cd="arith1" name="plus"/><OMI>2</OMI><OMI>3</OMI></OMA>')
    { asciimath: :to_asciimath, latex: :to_latex, unicode: :to_unicodemath,
      mathml: :to_mathml, omml: :to_omml, html: :to_html }.each do |input, writer|
      formula = Plurimath::Math.parse(expression.public_send(writer), input)
      expect(Plurimath::Math.parse(formula.to_openmath, :openmath).evaluate.value).to eq(5)
    end
  end

  it "uses operator precedence and exact fractions in the writer" do
    ["1 + 2 * 3", "(1 + 2) * 3", "-2", "1/4", "x^2"].zip([7, 9, -2, Rational(1, 4), 9]).each do |input, result|
      formula = Plurimath::Math.parse(input, :asciimath)
      expect(Plurimath::Math.parse(formula.to_openmath, :openmath).evaluate(x: 3).value).to eq(result)
    end
    expect { Plurimath::Math.parse("sin(x)", :asciimath).to_openmath }
      .to raise_error(Plurimath::Math::ParseError)
  end

  it "accepts CLI OpenMath input and output, including HTML and UnitsML output" do
    require "plurimath/cli"
    input = '<OMOBJ xmlns="http://www.openmath.org/OpenMath"><OMI>2</OMI></OMOBJ>'
    %w[asciimath html unitsml].each do |output|
      expect { Plurimath::Cli.start(["convert", "--input", input, "--input-format", "openmath", "--output-format", output]) }
        .to output(/2/).to_stdout
    end
    expect { Plurimath::Cli.start(["convert", "--input", "2", "--output-format", "openmath"]) }
      .to output(/OMOBJ/).to_stdout
  end

  it "decodes hexadecimal floats and retains their lexical source" do
    formula = openmath('<OMF hex="3FF0000000000000"/>')
    expect(formula.evaluate.value).to eq(1.0)
    expect(formula.to_openmath).to include('hex="3FF0000000000000"')
  end

  it "refuses unknown XML children and attributes before the model can drop them" do
    ['<OMI bogus="yes">1</OMI>', "<OMI>1</OMI><UNSUPPORTED/>"].each do |body|
      expect { openmath(body) }.to raise_error(Plurimath::Openmath::UnsupportedError)
    end
  end

  it "retains mixed child order in the published gem's model" do
    formula = openmath('<OMA><OMS cd="arith1" name="minus"/><OMI>10</OMI><OMV name="x"/></OMA>')
    expect(formula.evaluate(x: 3).value).to eq(7)
  end

  it "requires a published CD binding before converting an application" do
    table = Openmath::Evaluation::BindingTable.default
    allow(Openmath::Evaluation::BindingTable).to receive(:default).and_return(table)
    allow(table).to receive(:lookup).with("arith1", "plus").and_return(nil)
    expect { openmath('<OMA><OMS cd="arith1" name="plus"/><OMI>1</OMI><OMI>2</OMI></OMA>') }
      .to raise_error(Plurimath::Openmath::UnsupportedError)
  end

  it "serializes ordinary typed evaluation refusals as OpenMath errors" do
    formula = openmath('<OMA><OMS cd="arith1" name="divided_by"/><OMI>1</OMI><OMI>0</OMI></OMA>')
    expect { formula.evaluate }.to raise_error(Plurimath::Errors::Evaluation::DivisionByZeroError) do |error|
      xml = error.to_openmath
      expect(xml).to include("<OME>", "DivisionByZeroError", "divided by 0")
      expect { Plurimath::Math.parse(xml, :openmath).to_asciimath }
        .to raise_error(Plurimath::Openmath::UnsupportedError)
    end
  end

  it "preserves edited CD identities when rebuilding the Formula" do
    formula = openmath('<OMS cd="custom" name="alpha" cdbase="https://example.org/cd"/>')
    formula.value.first.cd = "edited"
    expect(formula.to_openmath).to include('cd="edited"')
  end

  it "refuses non-finite literals and unsupported numeric bases explicitly" do
    expect { openmath('<OMF dec="INF"/>') }.to raise_error(Plurimath::Openmath::UnsupportedError)
    formula = Plurimath::Math::Formula.new([Plurimath::Math::Number.new("10", base: 16)])
    expect { formula.to_openmath }.to raise_error(Plurimath::Openmath::UnsupportedError)
  end

  it "refuses a binomial coefficient rather than writing division" do
    fraction = Plurimath::Math::Function::Frac.new(
      Plurimath::Math::Number.new("5"), Plurimath::Math::Number.new("2")
    )
    fraction.options = { choose: true }
    expect { Plurimath::Math::Formula.new([fraction]).to_openmath }
      .to raise_error(Plurimath::Openmath::UnsupportedError)
  end
end
