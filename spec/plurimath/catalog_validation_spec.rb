require "spec_helper"

RSpec.describe Plurimath::Catalog::Validation do
  let(:entry) do
    Plurimath::Math::Function::Sum.catalog_entry
  end

  it "rejects unsafe identity, missing fields, invalid types and format records" do
    invalid = [
      entry.merge("name" => "../sum"),
      entry.merge("kind" => "operator"),
      entry.merge("arity" => "binary"),
      entry.merge("description" => 12),
      entry.merge("reference" => "javascript:bad"),
      entry.merge("reference" => "https:///missing-host"),
      entry.except("latexmath"),
      entry.merge(unknown: true),
      entry.merge("mathml" => nil),
      entry.merge("formats" => {}),
      entry.merge("formats" => entry["formats"].merge("mathml" => { "status" => "unknown", "notes" => [] })),
      entry.merge("formats" => entry["formats"].merge("mathml" => { "status" => "limited", "notes" => [] })),
    ]
    invalid.each do |candidate|
      expect { described_class.validate!(candidate) }.to raise_error(Plurimath::Catalog::InvalidEntryError)
    end
  end

  it "rejects invalid collection shapes with a contract error" do
    [nil, {}, "entries"].each do |value|
      expect { described_class.validate_all!(value) }
        .to raise_error(Plurimath::Catalog::InvalidEntryError, /must be an Array/)
    end
  end

  it "rejects duplicate kind/name identities even if arities differ" do
    binary = entry.merge("type" => "binary", "arity" => "binary")
    expect { described_class.validate_all!([entry, binary]) }
      .to raise_error(Plurimath::Catalog::InvalidEntryError, /Duplicate catalog identity: function\/sum/)
  end

  it "allows a function and symbol to share a slug" do
    symbol = Plurimath::Catalog::Entry.build(
      name: entry["name"], kind: :symbol, type: :symbol, arity: nil,
      formula: Plurimath::Math::Formula.new([Plurimath::Math::Number.new("1")])
    )
    expect(described_class.validate_all!([entry, symbol])).to eq([entry, symbol])
  end
end
