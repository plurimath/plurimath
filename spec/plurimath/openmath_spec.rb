# frozen_string_literal: true

require "spec_helper"

# The :openmath notation (plurimath#585): OpenMath XML parses through the
# openmath gem into a Formula; the bound content-dictionary core renders in
# every target; symbols outside the converter's table refuse.
RSpec.describe Plurimath::Openmath do
  NS = "http://www.openmath.org/OpenMath"

  def parse(body)
    Plurimath::Math.parse(%(<OMOBJ xmlns="#{NS}">#{body}</OMOBJ>), :openmath)
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

  it "converts the comparison symbols" do
    expect(parse('<OMA><OMS cd="relation1" name="eq"/><OMI>1</OMI><OMI>1</OMI></OMA>').value)
      .to include(Plurimath::Math::Symbols::Equal)
    expect(parse('<OMA><OMS cd="relation1" name="lt"/><OMI>1</OMI><OMI>2</OMI></OMA>').value)
      .to include(Plurimath::Math::Symbols::Less)
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
end
