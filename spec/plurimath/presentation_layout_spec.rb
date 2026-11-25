# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Presentation profile layout", engine_loop: :always do
  let(:profile_class) { Plurimath::PresentationProfile }
  let(:math) { Plurimath::Math }
  let(:function) { Plurimath::Math::Function }

  def symbol(name)
    Plurimath::Math::Symbols::Symbol.new(name)
  end

  def formula(node)
    Plurimath::Math::Formula.new([node])
  end

  def xml(source)
    Nokogiri::XML(source) { |config| config.strict }
  end

  def nodes(source, name)
    xml(source).xpath("//*[local-name()='#{name}']")
  end

  def profile(**options)
    profile_class.new(**options)
  end

  def limit_value(source)
    nodes(source, "limLoc").first&.attribute_with_ns(
      "val", "http://schemas.openxmlformats.org/officeDocument/2006/math"
    )&.value
  end

  it "uses all four character classes only after semantic declarations" do
    selected = profile(fallback_italics: { upperroman: false, lowerroman: true,
                                          uppergreek: false, lowergreek: false })
    value = math::Formula.new(%w[A x Γ α π].map { |name| symbol(name) })
    output = value.to_mathml(profile: selected, context: { "π" => :variable })
    expect(nodes(output, "mi").map { |node| node["mathvariant"] }).to eq(
      %w[normal italic normal normal italic],
    )
    expect(nodes(value.to_omml(profile: selected), "sty").map { |node| node.attributes.values.first.value }).to eq(
      %w[p i p p p],
    )
  end

  it "makes multi-letter identifiers upright while leaving unconfigured single letters alone" do
    value = math::Formula.new([symbol("velocity"), symbol("x")])
    expect(nodes(value.to_mathml(profile: profile), "mi").map { |node| node["mathvariant"] }).to eq(["normal", nil])
  end

  it "does not restyle explicit font markup with fallback preferences" do
    value = formula(function::FontStyle.new(symbol("A"), "italic"))
    expect(value.to_mathml(profile: profile(fallback_italics: { upperroman: false }))).to eq(value.to_mathml)
  end

  { vertical: "bar", slanted: "skw", inline: "lin" }.each do |layout, type|
    it "renders #{layout} fractions in both XML formats without changing the model" do
      value = formula(function::Frac.new(symbol("a"), symbol("b")))
      before = [value.to_json, value.to_mathml, value.to_omml]
      selected = profile(fraction_layout: layout)
      output = value.to_mathml(profile: selected)
      if layout == :inline
        expect(nodes(output, "mfrac")).to be_empty
        expect(nodes(output, "mo").map(&:text)).to eq(["(", ")", "/", "(", ")"])
      else
        expect(nodes(output, "mfrac").first["bevelled"]).to eq((layout == :slanted).to_s)
      end
      properties = nodes(value.to_omml(profile: selected), "fPr").first
      expect(properties.element_children.map { |node| node.name }).to eq(%w[type ctrlPr])
      expect(properties.element_children.first.attributes.values.first.value).to eq(type)
      expect([value.to_json, value.to_mathml, value.to_omml]).to eq(before)
    end
  end

  it "keeps compound inline fraction operands grouped" do
    value = Plurimath::Math.parse("(a+b)/(c+d)", :asciimath)
    output = value.to_mathml(profile: profile(fraction_layout: :inline))
    expect(nodes(output, "math").first.text.gsub(/\s/, "")).to eq("(a+b)/(c+d)")
  end

  [{ bevelled: "false" }, { bevelled: "true" }, { linethickness: "0" }, { choose: true }].each do |options|
    it "preserves explicit fraction options #{options.inspect}" do
      value = formula(function::Frac.new(symbol("a"), symbol("b"), options))
      selected = profile(fraction_layout: :inline)
      expect(value.to_mathml(profile: selected)).to eq(value.to_mathml)
      expect(value.to_omml(profile: selected)).to eq(value.to_omml)
    end
  end

  { side: ["msubsup", "subSup"], above_below: ["munderover", "undOvr"] }.each do |position, (tag, location)|
    %i[Sum Int].each do |name|
      it "places #{name} limits #{position} in MathML and OMML" do
        value = formula(function.const_get(name).new(symbol("a"), symbol("b"), symbol("x")))
        selected = profile(sum_limits: position, integral_limits: position)
        expect(nodes(value.to_mathml(profile: selected), tag).length).to eq(1)
        expect(limit_value(value.to_omml(profile: selected))).to eq(location)
      end
    end
  end

  it "uses single-limit tags without extra placeholder children" do
    %i[Sum Int].each do |name|
      [[symbol("a"), nil, "munder"], [nil, symbol("b"), "mover"]].each do |lower, upper, tag|
        value = formula(function.const_get(name).new(lower, upper, symbol("x")))
        output = value.to_mathml(profile: profile(sum_limits: :above_below, integral_limits: :above_below))
        expect(nodes(output, tag).first.element_children.length).to eq(2)
      end
    end
  end

  it "applies limits to generic nary sums and integrals, preserving explicit type" do
    [Plurimath::Math::Symbols::Sum.new, Plurimath::Math::Symbols::Int.new].each do |operator|
      selected = profile(sum_limits: :above_below, integral_limits: :above_below)
      value = formula(function::Nary.new(operator, symbol("a"), symbol("b"), symbol("x")))
      expect(nodes(value.to_mathml(profile: selected), "munderover").length).to eq(1)
      expect(limit_value(value.to_omml(profile: selected))).to eq("undOvr")
      explicit = formula(function::Nary.new(operator, symbol("a"), symbol("b"), symbol("x"), { type: "subSup" }))
      expect(explicit.to_mathml(profile: selected)).to eq(explicit.to_mathml)
      expect(explicit.to_omml(profile: selected)).to eq(explicit.to_omml)
    end
  end

  it "leaves other nary symbols on their own layout" do
    value = formula(function::Nary.new(Plurimath::Math::Symbols::Prod.new, symbol("a"), symbol("b"), symbol("x")))
    selected = profile(sum_limits: :above_below, integral_limits: :above_below)
    expect(value.to_mathml(profile: selected)).to eq(value.to_mathml)
    expect(value.to_omml(profile: selected)).to eq(value.to_omml)
  end

  it "replaces exact function/operator tokens once without changing stored semantics" do
    value = Plurimath::Math.parse("sin(x)+sum_a^b x", :asciimath)
    before = value.to_json
    selected = profile(symbols: { "sin" => "sen", "∑" => "Σ", "Σ" => "Q" })
    expect(nodes(value.to_mathml(profile: selected), "mi").map(&:text)).to include("sen")
    expect(nodes(value.to_mathml(profile: selected), "mo").map(&:text)).to include("Σ")
    omml = value.to_omml(profile: selected)
    expect(nodes(omml, "t").map(&:text)).to include("sen")
    expect(nodes(omml, "chr").first.attributes.values.first.value).to eq("Σ")
    expect(value.to_json).to eq(before)
  end

  it "escapes replacement text as XML content" do
    value = formula(symbol("x"))
    expect(nodes(value.to_mathml(profile: profile(symbols: { "x" => "x<y" })), "mi").first.text).to eq("x<y")
    expect(nodes(value.to_omml(profile: profile(symbols: { "x" => "x<y" })), "t").first.text).to eq("x<y")
  end

  it "sets operator spacing in MathML and preserves explicitly requested spacing" do
    value = Plurimath::Math.parse("a+b", :asciimath)
    selected = profile(operator_spacing: { "+" => { lspace: "0.1em", rspace: "0.2em" } })
    operator = nodes(value.to_mathml(profile: selected), "mo").first
    expect([operator["lspace"], operator["rspace"]]).to eq(%w[0.1em 0.2em])
    expect(value.to_omml(profile: selected)).to eq(value.to_omml)
    explicit = formula(symbol("+"))
    explicit.value.first.options = { rspace: "0.5em" }
    operator = nodes(explicit.to_mathml(profile: selected), "mo").first
    expect(operator["rspace"]).to eq("0.5em")
  end

  it "exports document limit defaults separately from equation XML" do
    selected = profile(sum_limits: :side, integral_limits: :above_below)
    document = xml(selected.to_omml_math_properties)
    expect(document.root.name).to eq("mathPr")
    expect(document.root.element_children.map(&:name)).to eq(%w[intLim naryLim])
    expect(document.root.element_children.map { |node| node.attributes.values.first.value }).to eq(%w[undOvr subSup])
    expect(nodes(formula(symbol("x")).to_omml(profile: selected), "mathPr")).to be_empty
  end

  it "keeps all profile options through split-line MathML and OMML" do
    value = math::Formula.new([function::Frac.new(symbol("a"), symbol("b")),
                               function::Linebreak.new, symbol("A")])
    selected = profile(fraction_layout: :slanted, fallback_italics: { upperroman: false })
    output = value.to_mathml(profile: selected, split_on_linebreak: true)
    expect(output.scan('<math ').length).to eq(2)
    # A split render returns sibling documents; parse each line independently.
    expect(output).to include('bevelled="true"', 'mathvariant="normal"')
    expect(nodes(value.to_omml(profile: selected, split_on_linebreak: true), "type").first.attributes.values.first.value).to eq("skw")
  end

  it "copies and freezes caller settings" do
    replacement = +"sen"
    width = +"0.2em"
    selected = profile(symbols: { "sin" => replacement }, operator_spacing: { "+" => { rspace: width } })
    replacement.replace("changed")
    width.replace("bad")
    output = Plurimath::Math.parse("sin(x)+y", :asciimath).to_mathml(profile: selected)
    expect(nodes(output, "mi").map(&:text)).to include("sen")
    expect(nodes(output, "mo").find { |node| node.text == "+" }["rspace"]).to eq("0.2em")
  end

  it "rejects invalid options before rendering" do
    [{ fraction_layout: :unknown }, { sum_limits: :unknown }, { integral_limits: :unknown },
     { fallback_italics: { uppergreek: nil } }, { fallback_italics: { typo: true } },
     { symbols: [] }, { symbols: { "x" => "" } }, { symbols: { "x" => "&" } },
     { operator_spacing: { "+" => { rspace: "invalid" } } }].each do |settings|
      expect { profile(**settings) }.to raise_error(ArgumentError)
    end
  end
end
