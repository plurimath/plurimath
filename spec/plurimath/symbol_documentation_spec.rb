require "spec_helper"

RSpec.describe Plurimath::SymbolDocumentation do
  describe "a concrete symbol (Alpha)" do
    let(:klass) { Plurimath::Math::Symbols::Alpha }

    it "derives the slug and type" do
      expect(klass.catalog_name).to eq("alpha")
      expect(klass.catalog_type).to eq(:symbol)
    end

    it "uses the glyph itself as the example" do
      expect(klass.example_formula).to be_a(Plurimath::Math::Formula)
    end

    it "is documented because it renders a glyph" do
      expect(klass.documented?).to be(true)
    end

    it "builds a lean entry — no description or reference" do
      entry = klass.catalog_entry
      expect(entry.keys).to contain_exactly(
        "name", "type", "asciimath", "latexmath", "mathml", "omml"
      )
      expect(entry["name"]).to eq("alpha")
      expect(entry["type"]).to eq("symbol")
      expect(entry["asciimath"]).to eq("alpha")
      expect(entry["latexmath"]).to eq("\\alpha")
    end
  end

  it "excludes the abstract bases that render nothing" do
    expect(Plurimath::Math::Symbols::Symbol.documented?).to be(false)
    expect(Plurimath::Math::Symbols::Paren.documented?).to be(false)
  end
end
