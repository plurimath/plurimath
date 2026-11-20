# frozen_string_literal: true

require "spec_helper"

RSpec.describe "LaTeX boxed expressions", engine_loop: :always do
  def parse(input)
    Plurimath::Math.parse(input, :latex)
  end

  def box(contents)
    Plurimath::Math::Function::Menclose.new("box", contents)
  end

  it "maps a boxed symbol to a box enclosure" do
    expect(parse('\\boxed{x}')).to eq(
      Plurimath::Math::Formula.new([box(Plurimath::Math::Symbols::Symbol.new("x"))])
    )
  end

  it "keeps all terms inside the enclosure" do
    expect(parse('\\boxed{x+1}')).to eq(
      Plurimath::Math::Formula.new([box(parse("x+1"))])
    )
  end

  it "preserves a nested box" do
    expect(parse('\\boxed{\\boxed{x}}')).to eq(
      Plurimath::Math::Formula.new([box(box(Plurimath::Math::Symbols::Symbol.new("x")))])
    )
  end

  it "preserves a fraction inside the box" do
    expect(parse('\\boxed{\\frac{a}{b}}')).to eq(
      Plurimath::Math::Formula.new([box(parse('\\frac{a}{b}').value.first)])
    )
  end

  it "preserves an empty enclosure" do
    xml = Nokogiri::XML(parse('\\boxed{}').to_mathml) { |config| config.noblanks }
    enclosures = xml.xpath("//*[local-name()='menclose']")

    expect(enclosures.size).to eq(1)
    expect(enclosures.first["notation"]).to eq("box")
    expect(enclosures.first.text).to eq("")
  end

  it "attaches a superscript to the enclosure" do
    expect(parse('\\boxed{x}^{2}')).to eq(
      Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          box(Plurimath::Math::Symbols::Symbol.new("x")),
          Plurimath::Math::Number.new("2"),
        ),
      ])
    )
  end

  it "attaches a subscript to the enclosure" do
    expect(parse('\\boxed{x}_{i}')).to eq(
      Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          box(Plurimath::Math::Symbols::Symbol.new("x")),
          Plurimath::Math::Symbols::Symbol.new("i"),
        ),
      ])
    )
  end

  ['\\boxed{x}_{i}^{2}', '\\boxed{x}^{2}_{i}'].each do |input|
    it "attaches both scripts to the enclosure in #{input}" do
      expect(parse(input)).to eq(
        Plurimath::Math::Formula.new([
          Plurimath::Math::Function::PowerBase.new(
            box(Plurimath::Math::Symbols::Symbol.new("x")),
            Plurimath::Math::Symbols::Symbol.new("i"),
            Plurimath::Math::Number.new("2"),
          ),
        ])
      )
    end
  end

  it "keeps a grouped exponent inside the subscript" do
    expect(parse('\\boxed{x}_{i^2}')).to eq(
      Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Base.new(
          box(Plurimath::Math::Symbols::Symbol.new("x")),
          Plurimath::Math::Function::Power.new(
            Plurimath::Math::Symbols::Symbol.new("i"),
            Plurimath::Math::Number.new("2"),
          ),
        ),
      ])
    )
  end

  it "renders nested enclosures with the box notation" do
    xml = Nokogiri::XML(parse('\\boxed{\\boxed{x}+1}').to_mathml) { |config| config.noblanks }
    enclosures = xml.xpath("//*[local-name()='menclose']")

    expect(enclosures.map { |node| node["notation"] }).to eq(%w[box box])
    expect(enclosures.first.text).to eq("x+1")
    expect(enclosures.last.text).to eq("x")
  end

  it "keeps the existing overline mapping" do
    expect(parse('\\overline{x}')).to eq(
      Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Bar.new(Plurimath::Math::Symbols::Symbol.new("x")),
      ])
    )
  end
end
