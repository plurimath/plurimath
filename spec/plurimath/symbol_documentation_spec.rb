require "spec_helper"
require "open3"
require "rbconfig"

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

  it "ignores anonymous symbol subclasses without changing the catalog" do
    code = <<~RUBY
      require "plurimath"
      original = Plurimath::Catalog.classes
      direct = Class.new(Plurimath::Math::Symbols::Symbol)
      nested = Class.new(Plurimath::Math::Symbols::Alpha)
      abort "anonymous class is documented" if direct.documented? || nested.documented?
      abort "catalog changed" unless Plurimath::Catalog.classes == original
      puts "anonymous subclasses excluded"
    RUBY
    output, error, status = Open3.capture3(
      RbConfig.ruby, "-I", File.expand_path("../../lib", __dir__), "-e", code
    )
    expect(status.success?).to be(true), error
    expect(output).to include("anonymous subclasses excluded")
  end
end
