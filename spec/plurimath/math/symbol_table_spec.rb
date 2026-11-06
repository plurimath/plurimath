# frozen_string_literal: true

RSpec.describe Plurimath::Math::SymbolTable do
  subject(:table) { described_class.new([["+", "Plus"], ["(", "Paren::Lround"]]) }

  it "resolves an entry to its class on lookup" do
    expect(table["+"]).to be(Plurimath::Math::Symbols::Plus)
    expect(table.fetch("(")).to be(Plurimath::Math::Symbols::Paren::Lround)
    expect(table["missing"]).to be_nil
    expect(table.fetch("missing", :none)).to eq(:none)
  end

  it "behaves as a Hash of classes for every other method" do
    expect(table).to be_a(Hash)
    expect(table.values).to eq([Plurimath::Math::Symbols::Plus,
                                Plurimath::Math::Symbols::Paren::Lround])
    expect(table.to_a.first).to eq(["+", Plurimath::Math::Symbols::Plus])
    expect(table).to eq("+" => Plurimath::Math::Symbols::Plus,
                        "(" => Plurimath::Math::Symbols::Paren::Lround)
  end

  it "keeps keys and their order without resolving" do
    expect(table.keys).to eq(["+", "("])
    expect(table.raw_pairs).to eq([["+", "Plus"], ["(", "Paren::Lround"]])
  end
end
