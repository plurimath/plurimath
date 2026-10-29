# frozen_string_literal: true

require_relative "shared_symbol_fixtures"

RSpec.shared_examples "shared symbol renderings" do |id|
  it "matches the shared AsciiMath string" do
    row = SharedSymbolFixtures.fetch(id, described_class)
    symbol = described_class.new
    actual = if row.fetch("asciimath_explicit_empty_options")
               symbol.to_asciimath(options: {})
             else
               symbol.to_asciimath
             end
    expect(actual).to eq(row.fetch("expected").fetch("asciimath"))
  end

  it "matches the shared LaTeX string" do
    row = SharedSymbolFixtures.fetch(id, described_class)
    expect(described_class.new.to_latex).to eq(row.fetch("expected").fetch("latex"))
  end

  it "matches the shared UnicodeMath string" do
    row = SharedSymbolFixtures.fetch(id, described_class)
    expect(described_class.new.to_unicodemath).to eq(row.fetch("expected").fetch("unicodemath"))
  end

  it "matches the shared OMML fragment" do
    row = SharedSymbolFixtures.fetch(id, described_class)
    expect(described_class.new.to_omml_without_math_tag(true)).to eq(row.fetch("expected").fetch("omml"))
  end

  it "matches the shared MathML fragment" do
    row = SharedSymbolFixtures.fetch(id, described_class)
    actual = dump_ox_nodes(described_class.new.to_mathml_without_math_tag(row.fetch("mathml_intent"))).strip
    expect(actual).to eq(row.fetch("expected").fetch("mathml"))
  end

  it "matches the shared HTML string" do
    row = SharedSymbolFixtures.fetch(id, described_class)
    expect(described_class.new.to_html).to eq(row.fetch("expected").fetch("html"))
  end
end
