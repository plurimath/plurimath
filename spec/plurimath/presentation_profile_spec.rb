# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::PresentationProfile, engine_loop: :always do
  let(:profile) { :iso_80000_2 }

  def parse(input)
    Plurimath::Math.parse(input, :asciimath)
  end

  def identifiers(xml)
    Nokogiri::XML(xml).xpath("//*[local-name()='mi']").map do |token|
      [token.text, token["mathvariant"]]
    end
  end

  def runs(xml)
    ns = { "m" => "http://schemas.openxmlformats.org/officeDocument/2006/math" }
    Nokogiri::XML(xml).xpath("//m:r", ns).map do |run|
      [run.at_xpath("./m:t", ns)&.text,
       run.at_xpath("./m:rPr/m:sty", ns)&.attribute_with_ns("val", ns["m"])&.value]
    end
  end

  %w[pi π e].each do |input|
    it "renders #{input} explicitly upright in MathML and OMML (#129)" do
      formula = parse(input)
      name = input == "pi" ? "π" : input
      expect(identifiers(formula.to_mathml(profile: profile))).to eq([[name, "normal"]])
      expect(runs(formula.to_omml(profile: profile))).to eq([[name, "p"]])
    end
  end

  ["Pi(n,varphi,k)", "F(x)", "G(x)", "H(x)"].each do |input|
    it "treats #{input} as a context-free function (#142)" do
      formula = parse(input)
      name = input.start_with?("Pi") ? "Π" : input[0]
      expect(identifiers(formula.to_mathml(profile: profile)).first).to eq([name, "normal"])
      expect(runs(formula.to_omml(profile: profile)).first).to eq([name, "p"])
      expect(identifiers(formula.to_mathml(profile: profile)).drop(1)).to all(satisfy { |_, variant| variant.nil? })
    end
  end

  it "keeps bare function names and arbitrary f(x) on the existing fallback" do
    formula = parse("Pi+F+G+H+f(x)")
    expect(identifiers(formula.to_mathml(profile: profile)).map(&:last)).to all(be_nil)
    expect(runs(formula.to_omml(profile: profile)).map(&:last)).to all(be_nil)
  end

  it "does not infer a function from square brackets" do
    expect(identifiers(parse("F[x]").to_mathml(profile: profile)).first).to eq(["F", nil])
  end

  it "uses explicit variables ahead of profile assumptions" do
    formula = parse("e+pi+F(x)")
    context = { "e" => :variable, "pi" => :variable, "F" => :variable }
    expect(identifiers(formula.to_mathml(profile: profile, context: context))).to eq(
      [["e", "italic"], ["π", "italic"], ["F", "italic"], ["x", nil]],
    )
    expect(runs(formula.to_omml(profile: profile, context: context))).to include(
      ["e", "i"], ["π", "i"], ["F", "i"],
    )
  end

  it "accepts explicit constant and context-free function declarations" do
    formula = parse("a+f(x)")
    context = { a: :constant, f: :context_free_function }
    expect(identifiers(formula.to_mathml(profile: profile, context: context))).to eq(
      [["a", "normal"], ["f", "normal"], ["x", nil]],
    )
    expect(runs(formula.to_omml(profile: profile, context: context))).to include(
      ["a", "p"], ["f", "p"],
    )
  end

  it "preserves explicit MathML variants ahead of semantic context" do
    formula = Plurimath::Math.parse(
      '<math xmlns="http://www.w3.org/1998/Math/MathML"><mi mathvariant="italic">π</mi></math>',
      :mathml,
    )
    context = { pi: :constant }
    expect(formula.to_mathml(profile: profile, context: context)).to eq(formula.to_mathml)
    expect(formula.to_omml(profile: profile, context: context)).to eq(formula.to_omml)
    expect(runs(formula.to_omml(profile: profile, context: context))).to eq([["π", "i"]])
  end

  it "preserves an explicit font around a whole expression" do
    formula = parse("bb(e+pi)")
    expect(formula.to_mathml(profile: profile)).to eq(formula.to_mathml)
    expect(formula.to_omml(profile: profile)).to eq(formula.to_omml)
  end

  it "projects nested argument sequences" do
    formula = parse("sqrt(Pi(n,varphi,k)+F(e))")
    expect(identifiers(formula.to_mathml(profile: profile))).to include(
      ["Π", "normal"], ["F", "normal"], ["e", "normal"], ["n", nil],
    )
    expect(runs(formula.to_omml(profile: profile))).to include(["Π", "p"], ["F", "p"], ["e", "p"])
  end

  it "allows profiles to declare different constants and function names" do
    custom = described_class.new(constants: ["a"], context_free_functions: ["f"])
    formula = parse("a+e+f(x)+F(x)")
    expect(identifiers(formula.to_mathml(profile: custom))).to eq(
      [["a", "normal"], ["e", nil], ["f", "normal"], ["x", nil], ["F", nil], ["x", nil]],
    )
  end

  it "does not change the stored model or later default output" do
    formula = parse("pi+e+Pi(n,varphi,k)")
    model = formula.to_json
    defaults = [formula.to_mathml, formula.to_omml]
    formula.to_mathml(profile: profile)
    formula.to_omml(profile: profile, context: { e: :variable })
    expect(formula.to_json).to eq(model)
    expect([formula.to_mathml, formula.to_omml]).to eq(defaults)
    expect(identifiers(defaults.first).map(&:last)).to all(be_nil)
    expect(runs(defaults.last).map(&:last)).to all(be_nil)
  end

  it "keeps inline display and split-line profile rendering" do
    formula = Plurimath::Math::Formula.new([
      Plurimath::Math::Symbols::Pi.new,
      Plurimath::Math::Function::Linebreak.new,
      Plurimath::Math::Symbols::Symbol.new("e"),
    ])
    xml = formula.to_mathml(profile: profile, display_style: false, split_on_linebreak: true)
    expect(xml.scan('displaystyle="false"').length).to eq(2)
    expect(xml.scan('mathvariant="normal"').length).to eq(2)
    expect(runs(formula.to_omml(profile: profile, split_on_linebreak: true))).to include(
      ["π", "p"], ["e", "p"],
    )
  end

  it "keeps number formatting independent of identifier semantics" do
    formatter = Plurimath::Formatter::Standard.new(locale: "de")
    formula = parse("1234.5+e")
    default = Nokogiri::XML(formula.to_mathml(formatter: formatter))
    selected = Nokogiri::XML(formula.to_mathml(formatter: formatter, profile: profile))
    expect(selected.xpath("//*[local-name()='mn']").map(&:text)).to eq(
      default.xpath("//*[local-name()='mn']").map(&:text),
    )
    expect(identifiers(selected.to_xml)).to include(["e", "normal"])
  end

  it "rejects an unknown profile" do
    expect { parse("e").to_mathml(profile: :unknown) }.to raise_error(ArgumentError, /Unknown presentation profile/)
  end

  it "requires a selected profile for semantic context" do
    expect { parse("e").to_omml(context: { e: :constant }) }.to raise_error(ArgumentError, /requires a presentation profile/)
  end

  it "rejects unknown or conflicting semantic roles" do
    expect { parse("e").to_mathml(profile: profile, context: { e: :unknown }) }.to raise_error(ArgumentError, /Unknown identifier role/)
    expect do
      parse("pi").to_mathml(profile: profile, context: { pi: :constant, "π" => :variable })
    end.to raise_error(ArgumentError, /Conflicting roles/)
  end
end
